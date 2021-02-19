enum Stage {
  WORKING, RESTING
}

enum ClockStatus {
  STOPPED,
  PROGRESSING
}

class ClockModel {
  static const WORKING_SECS = 10;
  static const REST_SECS = 6;

  int tomatoCount = 0;
  DateTime lastStartTime;

  ClockStatus clockStatus = ClockStatus.STOPPED;
  Stage stage = Stage.WORKING;

  ClockModel();

  ClockModel.fromJson(Map<String, dynamic> json):
    tomatoCount = json['tomatoCount'],
    lastStartTime = DateTime.parse(json['lastStartTime']),
    clockStatus = ClockStatus.values.firstWhere((value) => value.toString() == "${json['clockStatus']}"),
    stage = Stage.values.firstWhere((value) => value.toString() == "${json['stage']}");

  Map<String, dynamic> toJson() =>
    {
      'tomatoCount': tomatoCount,
      'lastStartTime': lastStartTime.toIso8601String(),
      'clockStatus': clockStatus.toString(),
      'stage': stage.toString()
    };
  
  void reset() {
    clockStatus = ClockStatus.STOPPED;
  }

  void start() {
    lastStartTime = DateTime.now();
    clockStatus = ClockStatus.PROGRESSING;
  }


  get remainingMs {
    if (clockStatus == ClockStatus.PROGRESSING) {
      var passedMs = DateTime.now().difference(lastStartTime).inMilliseconds;
      if (stage == Stage.WORKING) {
        return WORKING_SECS*1000 - passedMs; 
      } else {
        return REST_SECS*1000 - passedMs;
      }
    } else {
      return stage == Stage.WORKING ? WORKING_SECS*1000 : REST_SECS *1000;
    }
  }

  get totalSecs {
    if (stage == Stage.WORKING) {
      return WORKING_SECS; 
    } else {
      return REST_SECS;
    } 
  }

  get stageText {
    if (stage == Stage.WORKING) {
      return "工作"; 
    } else {
      return "休息";
    }   
  }

  void finish() {
    if (stage == Stage.WORKING) {
      tomatoCount ++;
      stage = Stage.RESTING;
      reset();

    } else {
      stage = Stage.WORKING;
      reset();
    }

  }

}