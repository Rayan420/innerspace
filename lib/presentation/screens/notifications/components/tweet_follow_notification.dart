import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:user_repository/data.dart';

class TweetFollowNotificationCard extends StatelessWidget {
  final FollowNotification notification;

  const TweetFollowNotificationCard({Key? key, required this.notification})
      : super(key: key);

  // Function to calculate and determine how long ago the notification was in days rounded
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
    final notificationTime = notification
        .createdAt; // Assuming you have this property in your FollowNotification class

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
                  Text(notification.senderName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 1.5),
                  Text('followed you',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
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
                          backgroundImage: notification.senderImage != null
                              ? NetworkImage(notification.senderImage!)
                              : AssetImage('assets/images/profile1.png')
                                  as ImageProvider,
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: tPrimaryColor,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: Text(
                            'follow',
                            style: TextStyle(
                              color: tWhiteColor, // Set the text color to white
                              fontSize: 14, // Adjust the font size as needed
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(notification.senderName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    Text(
                        '@${notification.senderUsername} • ${calculateTimeAgo(notificationTime)}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400)),
                    Text(notification.senderBio ?? '',
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
