import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TimerStatus {
  COUNTING, STOPPED
}

class CircularTimer extends StatefulWidget {

  final int totalSecs;
  final int remainingSecs;
  final TimerStatus status;

  CircularTimer({this.totalSecs, this.remainingSecs, this.status});

  @override
  State<CircularTimer> createState() => _CircularTimerState();
  
}

class _CircularTimerState extends State<CircularTimer> {

  int _totalMs;
  int _remainingMs;
  Timer _timer;
  
  @override
  void initState() {
    super.initState();

    _updateProgress();

  }

  @override
  void didUpdateWidget(CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateProgress();
  }

  void _updateProgress() {
    if (_timer != null) {
      _timer.cancel();
    }
    setState(() {
      
      _totalMs = widget.totalSecs * 1000;
      _remainingMs = widget.remainingSecs * 1000;

    });

    if (widget.status == TimerStatus.COUNTING) {
      startTimer();
    }
  }

  void startTimer() {
    
    const tick = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(tick, 
      (timer) { 
        setState(() {
          if (_remainingMs == 0) {
            timer.cancel();
          } else {
            _remainingMs -= 100;

          }
        });
      });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  String getTimeText() {
    String min = (_remainingMs / 60000).floor().toString().padLeft(2, '0');
    String sec = (_remainingMs % 60000 / 1000).ceil().toString().padLeft(2, '0');

    return '$min : $sec';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center ,children: [
                SizedBox(
                  width: 200, height: 200, child: 
                  CircularProgressIndicator(value:_remainingMs/_totalMs)
                ),
                Text(getTimeText(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ]);
  }

}