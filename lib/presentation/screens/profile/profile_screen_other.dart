import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/helper.dart';
import 'package:innerspace/presentation/screens/home/widgets/post_card.dart';
import 'package:just_audio/just_audio.dart';
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/user.dart';

class ProfileScreenOther extends StatefulWidget {
  const ProfileScreenOther({
    Key? key,
    required this.isdarkmode,
    required this.user,
    required this.isFollowing,
    required this.onFollowChanged,
    required this.toggleFollowStatus,
    required this.posts,
    required this.timelineRepository,
  }) : super(key: key);

  final bool isdarkmode;
  final User user;
  final bool isFollowing;
  final ValueChanged<bool> onFollowChanged;
  final Future<void> Function() toggleFollowStatus;
  final List<Post>? posts;
  final TimelineRepository timelineRepository;

  @override
  _ProfileScreenOtherState createState() => _ProfileScreenOtherState();
}

class _ProfileScreenOtherState extends State<ProfileScreenOther>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isFollowing;
  bool _isLoading = false;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  int? currentlyPlayingIndex;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _isFollowing = widget.isFollowing;
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      }
      if (mounted) {
        // Check if the widget is mounted before calling setState
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleFollowStatus() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await widget.toggleFollowStatus();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFollowing = !_isFollowing; // Toggle the following status
        });
      }

      widget.onFollowChanged(_isFollowing);
    } catch (e) {
      // Handle error, e.g., show a snackbar
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error toggling follow status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '@',
              style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
            ),
            Text(
              widget.user.username,
              style: const TextStyle(fontSize: 24, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.user.userProfile.coverPicture!),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: 10.0,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage(widget.user.userProfile.profilePicture!),
                  backgroundColor: Colors.white,
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
                  const Text(
                    'Following',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.user.userProfile.followingCount.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text('Followers',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(widget.user.userProfile.followerCount.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.047,
                child: TextButton(
                  onPressed: _toggleFollowStatus,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        _isFollowing ? Colors.grey.shade500 : tPrimaryColor,
                    foregroundColor: tWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // Text color
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: tWhiteColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isFollowing ? 'Unfollow' : 'Follow',
                          style: TextStyle(
                            color: _isFollowing && !widget.isdarkmode
                                ? Colors.black
                                : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                "${widget.user.firstName} ${widget.user.lastName}",
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  widget.user.userProfile.bio ?? '',
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
              Text('Joined ${widget.user.dateJoined}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 6),
              const Icon(Iconsax.calendar5, color: Colors.grey, size: 15),
              const SizedBox(width: 5),
              Text('Born on ${widget.user.dateOfBirth}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TabBar(
            controller: _tabController,
            labelColor: tPrimaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: tPrimaryColor,
            tabs: const [
              Tab(text: 'Their Sound'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // generate the Posts
                widget.posts!.isEmpty
                    ? Center(
                        child: Text(
                          'No sound available yet.',
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
                        itemCount: widget.posts!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              PostCard(
                                timelineRepository: widget.timelineRepository,
                                post: widget.posts![index],
                                onTapPlayPause: () => _togglePlayPause(
                                    widget.posts![index].audioUrl, index),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  _audioPlayer.seek(newPosition < Duration.zero
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
      ),
    );
  }

  void _togglePlayPause(String audioUrl, int index) async {
    try {
      if (_audioPlayer.playing && currentlyPlayingIndex == index) {
        await _audioPlayer.pause();
      } else {
        if (mounted) {
          setState(() {
            currentlyPlayingIndex = index;
          });
        }
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
