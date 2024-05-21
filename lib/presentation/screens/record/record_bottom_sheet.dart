import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';
import 'package:innerspace/presentation/screens/record/audio_player_view.dart';
import 'package:innerspace/presentation/screens/record/audio_recording_view.dart';
import 'package:innerspace/presentation/screens/record/audio_wave.dart';
import 'package:innerspace/presentation/widgets/record_widgets/glowing_avatar.dart';

class RecordBottomSheet extends StatefulWidget {
  const RecordBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _RecordBottomSheetState createState() => _RecordBottomSheetState();
}

class _RecordBottomSheetState extends State<RecordBottomSheet> {
  late AudioRecorderController audioRecorderController;
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioRecorderController = context.read<AudioRecorderController>();
    audioRecorderController.recordDurationOutput.listen((duration) {
      if (duration >= 60) {
        setState(() {
          isRecording = false;
          isPaused = false;
        });
        audioRecorderController.stop((recording) {
          // Handle the stopped recording
          print("Recording automatically stopped after 60 seconds.");
        });
      }
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

  void _onDone() {
    setState(() {
      isRecording = false;
      isPaused = false;
      isPlaying = true; // Switch to audio player view
    });
    audioRecorderController.stop((recording) {
      // Handle the stopped recording
      print("Recording manually stopped.");
    });
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
        audioRecorderController.resume();
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

  void _onPost() {
    // Implement posting logic here
    print("Audio posted.");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isPlaying) {
      return AudioPlayerView(
        audioPath: '', // Pass audio path here
        onCancel: _onCancel,
        onPost: _onPost,
        isDarkMode: isDarkMode,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: RecordingView(
            isRecording: isRecording,
            isPaused: isPaused,
            onCancel: _onCancel,
            onDone: _onDone,
            onToggleRecording: _onToggleRecording,
          ),
        ),
      );
    }
  }
}
