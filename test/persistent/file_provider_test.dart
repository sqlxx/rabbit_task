import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabbit_task/model/clock.dart';
import 'package:rabbit_task/persistent/file_provider.dart';



void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final directory = await Directory.systemTemp.createTemp();

    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;

    });
  });

  group('ClockModel', () {
    test('Save clock model should be successful', () async {
      final file = FileProvider.file;
      var clockModel = new ClockModel();
      clockModel.clockStatus = ClockStatus.PROGRESSING;
      clockModel.lastStartTime = new DateTime.now();
      clockModel.passedSeconds = 5;
      clockModel.tomatoCount = 10;
      clockModel.stage = Stage.WORKING;

      await file.writeClockModel(clockModel);

      var value = await file.readClockModel();
      expect(value.lastStartTime, clockModel.lastStartTime);
      expect(value.stage, clockModel.stage);
      expect(value.passedSeconds, clockModel.passedSeconds);
      expect(value.tomatoCount, clockModel.tomatoCount);
      expect(value.clockStatus, clockModel.clockStatus);

    });
  });


}