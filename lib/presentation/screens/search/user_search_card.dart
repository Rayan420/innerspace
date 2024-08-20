import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/profile_bloc/profile_bloc.dart';
import 'package:innerspace/presentation/screens/profile/profile_screen.dart';
import 'package:innerspace/presentation/screens/profile/profile_screen_other.dart';
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/user.dart';

import '../../../constants/colors.dart';

class UserSearchCard extends StatefulWidget {
  const UserSearchCard({
    Key? key,
    required this.user,
    required this.userRepository,
    required this.timelineRepository,
  }) : super(key: key);

  final User user;
  final UserRepository userRepository;
  final TimelineRepository timelineRepository;

  @override
  State<UserSearchCard> createState() => _UserSearchCardState();
}

class _UserSearchCardState extends State<UserSearchCard> {
  bool _isLoading = false;
  bool _isFollowing = false;
  late StreamSubscription<User> _userSubscription;

  @override
  void initState() {
    super.initState();
    _checkFollowingStatus();
    _userSubscription = widget.userRepository.userStream.listen((updatedUser) {
      if (updatedUser.userId == widget.user.userId && mounted) {
        setState(() {
          _checkFollowingStatus();
        });
      }
    });
  }

  void _checkFollowingStatus() {
    _isFollowing = widget.userRepository.user!.following
        .any((followedUser) => followedUser.userId == widget.user.userId);
  }

  Future<void> _toggleFollowStatus() async {
    setState(() {
      _isLoading = true;
    });

    await widget.userRepository.followUnfollowUser(widget.user);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _checkFollowingStatus();
      });
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        // Navigate to the user's profile
        if (widget.user.userId == widget.userRepository.user!.userId) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => ProfileBloc(
                  userRepository: widget.userRepository,
                  timelineRepository: widget.timelineRepository,
                ),
                child: ProfileScreen(
                  isdarkmode: isDarkMode,
                  timelineRepository: widget.timelineRepository,
                ),
              ),
            ),
          );
        } else {
          List<Post>? posts =
              await widget.timelineRepository.loadUserPosts(widget.user.userId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreenOther(
                timelineRepository: widget.timelineRepository,
                posts: posts,
                user: widget.user,
                isdarkmode: isDarkMode,
                isFollowing: _isFollowing,
                onFollowChanged: (isFollowing) {
                  if (mounted) {
                    setState(() {
                      _isFollowing = isFollowing;
                    });
                  }
                },
                toggleFollowStatus: _toggleFollowStatus,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.user.userProfile.profilePicture !=
                              null &&
                          widget.user.userProfile.profilePicture!.isNotEmpty
                      ? NetworkImage(widget.user.userProfile.profilePicture!)
                      : AssetImage('assets/images/profile1.png')
                          as ImageProvider,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.user.firstName} ${widget.user.lastName}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '@${widget.user.username}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Visibility(
                  visible:
                      widget.user.userId != widget.userRepository.user!.userId,
                  child: SizedBox(
                    child: TextButton(
                      onPressed: _toggleFollowStatus,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            _isFollowing ? Colors.grey.shade500 : tPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                                color: _isFollowing && !isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.user.userProfile.bio != null &&
                widget.user.userProfile.bio!.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                widget.user.userProfile.bio!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
