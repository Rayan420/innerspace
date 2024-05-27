import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/notifications.dart';

import 'components/tweet_follow_notification.dart';
import 'components/tweet_like_notification.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key, required this.notificationRepository});
  final NotificationRepository notificationRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Notifications>>(
        stream: notificationRepository.notificationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                if (notification is LikeNotification) {
                  return TweetLikeNotificationCard(notification: notification);
                } else if (notification is FollowNotification) {
                  return TweetFollowNotificationCard(
                      notification: notification);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
