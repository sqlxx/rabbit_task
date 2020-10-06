enum Stage {
  WORKING, RESTING
}

enum ClockStatus {
  STOPPED,
  PROGRESSING,
  PAUSED
}

class ClockModel {
  static const WORKING_SECS = 300;
  static const REST_SECS = 60;

  int tomatoCount = 0;
  int passedSeconds = 0;
  DateTime lastStartTime;

  ClockStatus clockStatus = ClockStatus.STOPPED;
  Stage stage = Stage.WORKING;

  void reset() {
    clockStatus = ClockStatus.STOPPED;
    passedSeconds = 0;
  }

  void start() {
    lastStartTime = DateTime.now();
    clockStatus = ClockStatus.PROGRESSING;
  }

  void pause() {
    passedSeconds += DateTime.now().difference(lastStartTime).inSeconds;
    clockStatus = ClockStatus.PAUSED;
  }

  get remainingSecs {
    if (stage == Stage.WORKING) {
      return WORKING_SECS - passedSeconds; 
    } else {
      return REST_SECS - passedSeconds;
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