import 'dart:async';
import 'package:innerspace/data/controller/recording/audio_recorder_file_helper.dart';
import 'package:innerspace/data/models/record/recording_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as path;

class AudioRecorderController {
  final AudioRecorderFileHelper _audioRecorderFileHelper;
  AudioRecorderController(this._audioRecorderFileHelper);

  final StreamController<int> _recordDurationController = StreamController<int>.broadcast()..add(0);
  Sink<int> get recordDurationInput => _recordDurationController.sink;
  Stream<double> get amplitudeStream => _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 160)).map((amp) => amp.current);
  Stream<RecordState> get recordStateStream => _audioRecorder.onStateChanged();
  Stream<int> get recordDurationOutput => _recordDurationController.stream;

  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer;
  int _recordDuration = 0;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
      recordDurationInput.add(_recordDuration);
      print("Recording duration: $_recordDuration seconds");
    });
  }

  Future<void> start() async {
    final isMicPermissionGranted = await _checkMicPermissions();
    if (!isMicPermissionGranted) {
      print("Microphone permission not granted.");
      return;
    }

    try {
      final filePath = path.join((await _audioRecorderFileHelper.getRecordsDirectory).path, "${DateTime.now().millisecondsSinceEpoch}.m4a");
      await _audioRecorder.start(const RecordConfig(), path: filePath);
      _startTimer();
      print("Recording started. File path: $filePath");
    } catch (e) {
      print("Could not start the recording: $e");
    }
  }

  void resume() {
    _startTimer();
    _audioRecorder.resume();
    print("Recording resumed.");
  }

  Future<void> pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    print("Recording paused.");
  }

  Future<String?> stop(Function(RecordingModel? voiceNoteModel) onStop) async {
    final recordPath = await _audioRecorder.stop();
    if (recordPath != null) {
      onStop(RecordingModel(
        name: path.basename(recordPath),
        createAt: DateTime.now().subtract(Duration(seconds: _recordDuration)),
        path: recordPath,
      ));
      print("Recording stopped. File saved at: $recordPath");
    } else {
      onStop(null);
      print("Recording could not be stopped properly.");
    }
    _reset();
    return recordPath;
  }


  Future<void> delete() async {
    await pause();
    try {
      await _audioRecorderFileHelper.deleteAllRecordings();
      print("All recordings deleted.");
    } catch (e) {
      print("Could not delete the recordings: $e");
    }
    _reset();
  }

  void dispose() {
    _recordDurationController.close();
    _timer?.cancel();
    _timer = null;
    _audioRecorder.dispose();
    print("AudioRecorderController disposed.");
  }

  Future<bool> _checkMicPermissions() async {
    const micPermission = Permission.microphone;
    if (await micPermission.isGranted) return true;
    final permissionStatus = await micPermission.request();
    return permissionStatus.isGranted || permissionStatus.isLimited;
  }

  void _reset() {
    _recordDuration = 0;
    recordDurationInput.add(0);
    print("Recording state reset.");
  }
}
