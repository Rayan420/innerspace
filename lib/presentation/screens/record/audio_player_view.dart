import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/presentation/widgets/record_widgets/glowing_avatar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:innerspace/constants/colors.dart';

class AudioPlayerView extends StatefulWidget {
  final String audioPath;
  final VoidCallback onPost;
  final VoidCallback onCancel;
  final bool isDarkMode;
  final String imageUrl;

  const AudioPlayerView({
    Key? key,
    required this.audioPath,
    required this.onPost,
    required this.onCancel,
    required this.isDarkMode,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  late AudioPlayer _audioPlayer;
  late Stream<PlayerState> _playerStateStream;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer()..setFilePath(widget.audioPath);
    _playerStateStream = _audioPlayer.playerStateStream;
    print('Path for player set at ${widget.audioPath}');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    widget.isDarkMode ? tWhiteColor : tSecondaryColor,
              ),
              onPressed: widget.onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: widget.isDarkMode ? tBlackColor : tWhiteColor),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    widget.isDarkMode ? tWhiteColor : tSecondaryColor,
              ),
              onPressed: widget.onPost,
              child: Text(
                'Post',
                style: TextStyle(
                    color: widget.isDarkMode ? tBlackColor : tWhiteColor),
              ),
            ),
          ],
        ),
        const Text(
          'Listen to your recording',
          style: TextStyle(fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF144771), Color(0xFF071A2C)],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: StreamBuilder<PlayerState>(
            stream: _playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final playing = playerState?.playing ?? false;
              final processingState = playerState?.processingState;

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (playing && processingState != ProcessingState.completed)
                    GlowingAvatar(
                      imageUrl: widget.imageUrl,
                    )
                  else
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.imageUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  Controls(
                    audioPlayer: _audioPlayer,
                    processingState: processingState,
                    playing: playing,
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Post to: '),
            DropdownButton<String>(
              items: <String>['Timeline', 'Story'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ],
        ),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    Key? key,
    required this.audioPlayer,
    required this.processingState,
    required this.playing,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final ProcessingState? processingState;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    if (processingState == ProcessingState.completed) {
      return IconButton(
        onPressed: () {
          audioPlayer.seek(Duration.zero);
          audioPlayer.play();
        },
        icon: Icon(
          Icons.replay,
          color: Colors.white.withOpacity(0.8),
          size: 50,
        ),
      );
    } else if (!playing) {
      return IconButton(
        onPressed: audioPlayer.play,
        icon: const Icon(
          Iconsax.play,
          color: Colors.white,
          size: 50,
        ),
      );
    } else {
      return IconButton(
        onPressed: audioPlayer.pause,
        icon: const Icon(
          Iconsax.pause,
          color: Colors.white,
          size: 50,
        ),
      );
    }
  }
}
