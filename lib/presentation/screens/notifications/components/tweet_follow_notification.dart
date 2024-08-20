import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:user_repository/data.dart';

class TweetFollowNotificationCard extends StatefulWidget {
  final FollowNotification notification;
  final UserRepository userRepository;

  const TweetFollowNotificationCard({
    Key? key,
    required this.notification,
    required this.userRepository,
  }) : super(key: key);

  @override
  _TweetFollowNotificationCardState createState() =>
      _TweetFollowNotificationCardState();
}

class _TweetFollowNotificationCardState
    extends State<TweetFollowNotificationCard> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _checkFollowingStatus();
  }

  void _checkFollowingStatus() {
    _isFollowing = widget.userRepository.user!.following
        .any((user) => user.userId == widget.notification.senderId);
  }

  String calculateTimeAgo(DateTime notificationTime) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(notificationTime);
    final days = difference.inDays;
    final minutes = difference.inMinutes;

    if (minutes <= 2) {
      return 'now';
    } else if (days == 0) {
      return 'today';
    } else if (days == 1) {
      return '1d';
    } else {
      return '$days days';
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationTime = widget.notification.createdAt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Iconsax.user,
          color: tPrimaryColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.notification.senderName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 1.5),
                  Text(
                    'started following you',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: widget.notification.senderImage !=
                                  null
                              ? NetworkImage(widget.notification.senderImage!)
                              : AssetImage('assets/images/profile1.png')
                                  as ImageProvider,
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            await widget.userRepository
                                .followUnfollowUserFromNotif(
                                    widget.notification.senderId,
                                    widget.notification.senderName,
                                    widget.notification.senderUsername);

                            setState(() {
                              _isLoading = false;
                              _checkFollowingStatus();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: _isFollowing
                                ? Colors.grey.shade500
                                : tPrimaryColor,
                          ),
                          child: _isLoading
                              ? SizedBox(
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
                                    color: _isFollowing
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Text(widget.notification.senderName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    Text(
                        '@${widget.notification.senderUsername} • ${calculateTimeAgo(notificationTime)}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400)),
                    Text(widget.notification.senderBio ?? '',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
