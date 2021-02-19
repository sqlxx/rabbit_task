import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_task/model/clock.dart';

void main() {
  group("ClockModel", () {
    test('Test ClockModel fromJson', () {

      final jsonMap = {'tomatoCount': 10, 'passedSeconds': 5, 'lastStartTime': '2021-01-11T11:35:53.233528', 'clockStatus': 'ClockStatus.PROGRESSING', 'stage': 'Stage.WORKING'};

      final clockModel = ClockModel.fromJson(jsonMap);
      expect(clockModel.clockStatus.toString(),jsonMap['clockStatus']);
      expect(clockModel.lastStartTime.toIso8601String(), jsonMap['lastStartTime']);
      expect(clockModel.tomatoCount, jsonMap['tomatoCount']);
      expect(clockModel.stage.toString(), jsonMap['stage']); 
    });

    test("Test ClockModel toJson", () {
      final sut = new ClockModel();
      sut.clockStatus = ClockStatus.PROGRESSING;
      sut.lastStartTime = new DateTime.now();
      sut.tomatoCount = 10;
      sut.stage = Stage.WORKING;

      final jsonMap = sut.toJson();
      expect(jsonMap['clockStatus'], sut.clockStatus.toString());
      expect(jsonMap['lastStartTime'], sut.lastStartTime.toIso8601String());
      expect(jsonMap['tomatoCount'], sut.tomatoCount);
      expect(jsonMap['stage'], sut.stage.toString());
      print(jsonMap);
    });

  });
}