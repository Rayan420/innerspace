import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:innerspace/constants/helper.dart';
import 'package:innerspace/presentation/screens/home/story_screen.dart';
import 'package:innerspace/presentation/screens/home/widgets/post_card.dart';
import 'package:innerspace/presentation/screens/home/widgets/story_item.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer _audioPlayer;
  late Stream<PlayerState> _playerStateStream;

  @override
  void initState() {
    super.initState();
    context.read<TimelineBloc>().add(SubscribeToTimeline());
    _audioPlayer = AudioPlayer();
    _playerStateStream = _audioPlayer.playerStateStream;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    var isDarkMode = brightness == Brightness.dark;
    final List<Map<String, dynamic>> stories = [
      {
        'userName': 'John Doe',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      {
        'userName': 'Jane Smith',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
        'audioUrl':
            'https://cdn.pixabay.com/download/audio/2023/09/08/audio_b4bd5dcd5f.mp3?filename=mysterious-sci-fi-30-sec-background-music-165790.mp3',
      },
      {
        'userName': 'Alice Johnson',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      },
      {
        'userName': 'Bob Brown',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      },
      {
        'userName': 'Charlie Green',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Innerspace',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Stories section
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return StoryItem(
                  storyData: stories[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryScreen(
                          stories: stories,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          // New posts notification
          BlocBuilder<TimelineBloc, TimelineState>(
            builder: (context, state) {
              if (state is TimelineLoaded && state.newPosts.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    context.read<TimelineBloc>().add(RefreshTimeline());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.blueAccent,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'New posts available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Post section
          Expanded(
            child: BlocBuilder<TimelineBloc, TimelineState>(
              builder: (context, state) {
                if (state is TimelineLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  );
                } else if (state is TimelineLoaded && state.posts.isEmpty) {
                  return Center(
                    child: Text(
                      'No posts to listen to at the moment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey : Colors.black38,
                      ),
                    ),
                  );
                } else if (state is TimelineLoaded) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                          post: state.posts[index],
                          onTapPlayPause: () =>
                              _togglePlayPause(state.posts[index].audioUrl),
                          isPlaying: _audioPlayer.playing &&
                              _audioPlayer.currentIndex == index,
                          isLoading: _audioPlayer.processingState.index >
                              ProcessingState.loading.index);
                    },
                  );
                } else if (state is TimelineError) {
                  return Center(
                    child: Text('Failed to load posts: ${state.message}'),
                  );
                }
                return Container(); // Handle other states if necessary
              },
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause(String audioUrl) async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        final url = "";
        if (audioUrl.contains("localhost")) {
          String url = BackendUrls.replaceFromLocalhost(audioUrl);
          await _audioPlayer.setUrl(url);
        } else {
          String url = BackendUrls.replaceToLocalhost(audioUrl);
          await _audioPlayer.setUrl(url);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error toggling audio: $e');
    }
  }
}
