
import 'package:flutter/material.dart';
import 'package:rabbit_task/model/clock.dart';

import 'circular-timer.dart';

class TomatoClock extends StatefulWidget {

  @override
  _TomatoClockState createState() => _TomatoClockState();
}

class _TomatoClockState extends State<TomatoClock> {
  ClockModel _clockModel = new ClockModel();

  void startTimer() {
    
    setState(() {
      _clockModel.start();
    });
  }

  void resumeTimer() {

  }

  void pauseTimer() {
    setState(() {
      _clockModel.pause();
    });
  }


  String getButtonText() {
    switch(_clockModel.clockStatus) {
      case ClockStatus.STOPPED: return "开始" + _clockModel.stageText;
      case ClockStatus.PROGRESSING: return "暂停";
      case ClockStatus.PAUSED: return "继续";
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
        pauseTimer();
        break;
      case ClockStatus.PAUSED:
        startTimer();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_clockModel.stageText),
              CircularTimer(totalSecs: _clockModel.totalSecs, remainingSecs: _clockModel.remainingSecs, status: getTimerStatus(),),
              RaisedButton(child: Text(getButtonText()), onPressed: onButtonPressed)
              ]
            )
          ));
  }
}
