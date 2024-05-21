import 'dart:developer';
import 'dart:io';

import 'package:innerspace/data/models/record/recording_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AudioRecorderFileHelper {
  final String _recordsDirectoryName = "recording";
  String? _appDirPath;
  final int fetchLimit = 15;

  Future<String> get _getAppDirPath async {
    _appDirPath ??= (await getApplicationDocumentsDirectory()).path;
    return _appDirPath!;
  }

  Future<Directory> get getRecordsDirectory async {
    Directory recordDir =
        Directory(path.join((await _getAppDirPath), _recordsDirectoryName));

    if (!(await recordDir.exists())) {
      await recordDir.create();
    }
    print('Recording directory path: $recordDir');
    return recordDir;
  }

  Future<RecordingModel?> fetchFirstVoiceNote() async {
    var files = await getRecordsDirectory;

    if (files.listSync().isEmpty) {
      return null;
    }

    var file = files.listSync().first;
    return RecordingModel(
      name: path.basename(file.path),
      createAt: file.statSync().modified,
      path: file.path,
    );
  }

  Future<void> deleteAllRecordings() async {
    try {
      final Directory recordsDirectory = await getRecordsDirectory;
      final List<FileSystemEntity> files = recordsDirectory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          await file.delete();
        }
      }

      log('All recordings deleted');
    } catch (e) {
      throw "Error deleting recordings: $e";
    }
  }
}
