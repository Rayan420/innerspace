import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';
import 'package:innerspace/presentation/screens/record/audio_player_view.dart';
import 'package:innerspace/presentation/screens/record/audio_recording_view.dart';
import 'package:user_repository/data.dart';

class RecordBottomSheet extends StatefulWidget {
  const RecordBottomSheet({
    super.key,
    required this.timelineRepository,
    required this.userRepository,
  });

  final TimelineRepository timelineRepository;
  final UserRepository userRepository;

  @override
  _RecordBottomSheetState createState() => _RecordBottomSheetState();
}

class _RecordBottomSheetState extends State<RecordBottomSheet> {
  late AudioRecorderController audioRecorderController;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  String path = '';
  int _duration = 0;

  @override
  void initState() {
    super.initState();
    audioRecorderController = context.read<AudioRecorderController>();
    audioRecorderController.recordDurationOutput.listen((duration) {
      setState(() {
        _duration = duration;
        if (duration >= 60) {
          _onDone();
        }
      });
    });
  }

  @override
  void dispose() {
    audioRecorderController.dispose();
    super.dispose();
  }

  void _onCancel() {
    audioRecorderController.delete();
    Navigator.pop(context);
    print("Recording canceled.");
  }

  Future<void> _onDone() async {
    if (isRecording || isPaused) {
      await audioRecorderController.stop((recording) {
        if (recording != null) {
          setState(() {
            path = recording.path;
            isRecording = false;
            isPaused = false;
            isPlaying = true;
          });
          print("Recording manually stopped.");
        }
      });

      setState(() {
        isPlaying = true;
      });
      print("Recording duration on done: $_duration");
    }
  }

  void _onToggleRecording() async {
    if (isRecording) {
      await audioRecorderController.pause();
      setState(() {
        isRecording = false;
        isPaused = true;
      });
      print("Recording paused.");
    } else {
      if (isPaused) {
        await audioRecorderController.resume();
        setState(() {
          isRecording = true;
          isPaused = false;
        });
        print("Recording resumed.");
      } else {
        await audioRecorderController.start();
        setState(() {
          isRecording = true;
          isPaused = false;
        });
        print("Recording started.");
      }
    }
  }

  Future<void> _onPost() async {
    try {
      print("Posting audio. Duration: $_duration");

      final done = await widget.timelineRepository.createPost(
        audioFilePath: path,
        duration: _duration,
      );
      if (done) {
        audioRecorderController.delete();
        if (mounted) {
          print("Audio posted.");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isPlaying) {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? tSecondaryColor : tWhiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AudioPlayerView(
            audioPath: path,
            onCancel: _onCancel,
            onPost: _onPost,
            isDarkMode: isDarkMode,
            imageUrl: widget.userRepository.user!.userProfile.profilePicture!,
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? tSecondaryColor : tWhiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: RecordingView(
            isRecording: isRecording,
            isPaused: isPaused,
            onCancel: _onCancel,
            onDone: _onDone,
            onToggleRecording: _onToggleRecording,
            imageUrl: widget.userRepository.user!.userProfile.profilePicture!,
          ),
        ),
      );
    }
  }
}
