import 'package:flutter/material.dart';
import 'package:user_repository/data.dart';

class TweetLikeNotificationCard extends StatelessWidget {
  final LikeNotification notification;

  const TweetLikeNotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDownvoted = notification.type == 'DOWNVOTE';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            isDownvoted
                ? 'assets/images/downvoteClicked.png'
                : 'assets/images/upvote.png',
            width: 32,
            height: 32,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(notification.senderImage!),
                  ),
                  title: Text(
                    notification.senderName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    notification.type == 'UPVOTE'
                        ? 'Tuned in and UPVOTED your vibes!'
                        : 'Tuned into your audio with a different frequency.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                // Add more elements to enhance the design
              ],
            ),
          ),
        ],
      ),
    );
  }
}
