import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:user_repository/data.dart';

class TweetLikeNotificationCard extends StatelessWidget {
  final LikeNotification notification;

  const TweetLikeNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Iconsax.heart5,
          color: Colors.red,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: notification.senderImage != null
                    ? NetworkImage(notification.senderImage!)
                    : AssetImage('assets/images/profile1.png') as ImageProvider,
              ),
              Row(
                children: [
                  Text(notification.senderName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 1.5),
                  Text('liked your photo',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
