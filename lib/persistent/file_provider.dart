import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rabbit_task/model/clock.dart';

class FileProvider {
  FileProvider._();

  static final FileProvider file = FileProvider._();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _clockModelFile async {
    final path = await _localPath;
    return File('$path/clock_model');
  }

  Future<ClockModel> readClockModel() async {
    try {
      final file = await _clockModelFile;

      String clockModelJson = await file.readAsString();
      return new ClockModel.fromJson(jsonDecode(clockModelJson));
    } catch (e) {
      return new ClockModel();
    }
  }

  writeClockModel(ClockModel clockModel) async {
    final json = jsonEncode(clockModel.toJson());
    final file = await _clockModelFile;

    await file.writeAsString(json);
  }

}