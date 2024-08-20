import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/profile_bloc/profile_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/helper.dart';
import 'package:innerspace/presentation/screens/home/widgets/post_card.dart';
import 'package:innerspace/presentation/screens/profile/edit_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:user_repository/data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.isdarkmode, required this.timelineRepository});
  final TimelineRepository timelineRepository;
  final bool isdarkmode;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  int? currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    // Load the profile when the screen initializes
    context.read<ProfileBloc>().add(LoadProfile());
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
      setState(() {
        isPlaying = state.playing;
      });
    });
    widget.timelineRepository.loadOwnPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _navigateToEditScreen() async {
    // Await the result from the EditScreen
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: EditScreen(
            userRepository: context.read<ProfileBloc>().userRepository,
            isDarMode: widget.isdarkmode,
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Actions'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              // Add your settings button logic here
              Navigator.pop(context);
            },
            child: const Text('Settings'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // Trigger the logout event
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.pop(context);
            },
            child: const Text('Logout'),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Row(
                children: [
                  const Text('@',
                      style: TextStyle(fontSize: 24, fontFamily: 'Montserrat')),
                  Text(state.user.username ?? '',
                      style:
                          const TextStyle(fontSize: 24, fontFamily: 'Poppins')),
                ],
              );
            } else {
              return const Text('Profile');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showActionSheet(context);
            },
            icon: Icon(
              Iconsax.more,
              color: widget.isdarkmode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            final profile = user.userProfile;
            print(
                "USER UPDATED   ----- ${user.firstName} ${user.lastName} ${profile.bio!} ${profile.coverPicture} ${profile.profilePicture}");
            final posts = state.posts;
            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context)
                          .size
                          .width, // Expand to full width
                      child: Image.network(
                        BackendUrls.replaceFromLocalhost(
                            user.userProfile.coverPicture!),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      left: 10.0,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          BackendUrls.replaceFromLocalhost(user.userProfile
                              .profilePicture!), // Update profile picture
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const SizedBox(width: 108),
                    Column(
                      children: [
                        const Text('Following',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(user.userProfile.followingCount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text('Followers',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(user.userProfile.followerCount.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.23,
                      height: MediaQuery.of(context).size.height * 0.047,
                      child: TextButton(
                        onPressed: _navigateToEditScreen,
                        style: TextButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          foregroundColor: tWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text('Edit', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Text("${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        user.userProfile.bio ?? "",
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    const Icon(Iconsax.calendar5, color: Colors.grey, size: 15),
                    const SizedBox(width: 5),
                    Text('Joined ${user.dateJoined}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    const Icon(Iconsax.calendar5, color: Colors.grey, size: 15),
                    const SizedBox(width: 5),
                    Text('Born on ${user.dateOfBirth}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: tPrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: tPrimaryColor,
                  tabs: const [
                    Tab(text: 'Your Sound'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      posts.isEmpty
                          ? Center(
                              child: Text(
                                'Tap the mic to record a new post.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.isdarkmode
                                      ? Colors.grey
                                      : Colors.black38,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    PostCard(
                                      timelineRepository:
                                          widget.timelineRepository,
                                      post: posts[index],
                                      onTapPlayPause: () => _togglePlayPause(
                                          posts[index].audioUrl, index),
                                      isPlaying: _audioPlayer.playing &&
                                          currentlyPlayingIndex == index,
                                      isLoading: _audioPlayer.processingState ==
                                          ProcessingState.loading,
                                    ),
                                    Divider(
                                      color: Colors.grey[800],
                                      thickness: 1,
                                      height: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                      // Audio Progress Bar
                    ],
                  ),
                ),
                if (isPlaying)
                  StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      final duration = _audioPlayer.duration ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            min: 0.0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds
                                .toDouble()
                                .clamp(0.0, duration.inMilliseconds.toDouble()),
                            onChanged: (value) {
                              _audioPlayer
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_formatDuration(position)),
                                    IconButton(
                                      icon: Icon(Icons.replay_5),
                                      onPressed: () {
                                        final newPosition =
                                            position - Duration(seconds: 5);
                                        _audioPlayer.seek(
                                            newPosition < Duration.zero
                                                ? Duration.zero
                                                : newPosition);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(_audioPlayer.playing
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      onPressed: () {
                                        _audioPlayer.playing
                                            ? _audioPlayer.pause()
                                            : _audioPlayer.play();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.forward_5),
                                      onPressed: () {
                                        final newPosition =
                                            position + Duration(seconds: 5);
                                        _audioPlayer.seek(newPosition > duration
                                            ? duration
                                            : newPosition);
                                      },
                                    ),
                                  ],
                                ),
                                Text(_formatDuration(duration)),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  void _togglePlayPause(String audioUrl, int index) async {
    try {
      if (_audioPlayer.playing && currentlyPlayingIndex == index) {
        await _audioPlayer.pause();
      } else {
        setState(() {
          currentlyPlayingIndex = index;
        });
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
