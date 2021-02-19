
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rabbit_task/model/clock.dart';
import 'package:rabbit_task/persistent/file_provider.dart';

import 'circular_timer.dart';
import 'dart:developer' as developer;

class TomatoClock extends StatefulWidget {

  @override
  _TomatoClockState createState() => _TomatoClockState();
}

class _TomatoClockState extends State<TomatoClock> with WidgetsBindingObserver {
  static const platform = const MethodChannel('ind.sq.dev/battery');

  ClockModel _clockModel = new ClockModel();
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch(e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) async {

    switch(lifecycleState) {
      case AppLifecycleState.paused:
        await FileProvider.file.writeClockModel(this._clockModel);
        debugPrint("clockModel saved");
        break;
      case AppLifecycleState.resumed:
        var previousModel = await FileProvider.file.readClockModel();

        if (previousModel == null) {
          previousModel = new ClockModel();
        } if (previousModel.clockStatus == ClockStatus.PROGRESSING && previousModel.remainingMs <= 0) {
          previousModel.finish();
          debugPrint("the clock finished in background");
        } 
        setState(() {
          this._clockModel = previousModel; 
        });
        debugPrint("clockmodel restored");
        break;
      default:
        // Ignored 

    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void startTimer() {
    
    setState(() {
      _clockModel.start();
    });
  }

  void resetTimer() {
    setState(() {
      _clockModel.reset();
    });
  }

  String getButtonText() {
    switch(_clockModel.clockStatus) {
      case ClockStatus.STOPPED: return "开始" + _clockModel.stageText;
      case ClockStatus.PROGRESSING: return "取消";
      default: return "Unkonwn";
    }
  }

  TimerStatus getTimerStatus() {
    if (_clockModel.clockStatus == ClockStatus.PROGRESSING) {
      return TimerStatus.COUNTING;
    } else {
      return TimerStatus.STOPPED;
    }
  }

  void onButtonPressed() {
    switch(_clockModel.clockStatus) {
      case ClockStatus.STOPPED: 
        startTimer();
        break;
      case ClockStatus.PROGRESSING: 
        resetTimer();
        break;
    }
  }

  void onFinished() {
    developer.log("It's finished");
    setState(() {
      _clockModel.finish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('番茄个数'),
              Text('${_clockModel.tomatoCount}'),
              Text(_batteryLevel),
              ElevatedButton(child: Text("Get Battery Level"), onPressed: _getBatteryLevel),
              Text(_clockModel.stageText),
              CircularTimer(totalSecs: _clockModel.totalSecs, remainingMs: _clockModel.remainingMs, status: getTimerStatus(),onFinshed: onFinished,),
              RaisedButton(child: Text(getButtonText()), onPressed: onButtonPressed)
              ]
            )
          ),
        backgroundColor: Colors.teal[200],
      );
  }
}
