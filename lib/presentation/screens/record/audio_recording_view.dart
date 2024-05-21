import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/data/controller/recording/audi_recording_controller.dart';
import 'package:innerspace/presentation/screens/record/audio_wave.dart';
import 'package:innerspace/presentation/widgets/record_widgets/glowing_avatar.dart';

class RecordingView extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Function() onToggleRecording;

  const RecordingView({
    Key? key,
    required this.isRecording,
    required this.isPaused,
    required this.onCancel,
    required this.onDone,
    required this.onToggleRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode ? tWhiteColor : tSecondaryColor,
              ),
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: isDarkMode ? tBlackColor : tWhiteColor),
              ),
            ),
            if (isRecording || isPaused)
              Row(
                children: [
                  Icon(
                    Icons.fiber_manual_record,
                    color: isRecording ? Colors.red : Colors.grey,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(isRecording? 'Recording...' : 'Paused',
                      style: TextStyle(
                        color: isRecording ? Colors.red : Colors.grey,
                      )),
                ],
              ),
            if (isRecording || isPaused)
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isDarkMode ? tWhiteColor : tSecondaryColor,
                ),
                child: Text(
                  'Done',
                  style:
                      TextStyle(color: isDarkMode ? tBlackColor : tWhiteColor),
                ),
                onPressed: onDone,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (isRecording)
          const GlowingAvatar()
        else
          CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage('assets/images/profile1.png'),
            backgroundColor: Colors.grey.shade200,
          ),
        const Text(
          'What\'s on your mind?',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        if (isRecording || isPaused) const AudioWave(),
        if (isRecording || isPaused) _TimerText(isDarkMode: isDarkMode),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onToggleRecording,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: tPrimaryColor,
                child: Icon(
                  isRecording ? Iconsax.pause : Iconsax.microphone,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}

class _TimerText extends StatelessWidget {
  const _TimerText({Key? key, required this.isDarkMode}) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final audioRecorderController = context.watch<AudioRecorderController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<int>(
        initialData: 0,
        stream: audioRecorderController.recordDurationOutput,
        builder: (context, snapshot) {
          final durationInSec = snapshot.data ?? 0;

          final int minutes = durationInSec ~/ 60;
          final int seconds = durationInSec % 60;

          return Text(
            '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: isDarkMode ? tWhiteColor : tBlackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
