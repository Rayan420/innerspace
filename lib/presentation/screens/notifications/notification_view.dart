import 'package:flutter/material.dart';
import 'package:user_repository/src/models/notifications.dart';
import 'package:user_repository/data.dart';
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
      body: ValueListenableBuilder<List<Notifications>>(
        valueListenable: notificationRepository.notificationsNotifier,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return Center(child: Text('No notifications'));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              if (notification is LikeNotification) {
                return TweetLikeNotificationCard(notification: notification);
              } else if (notification is FollowNotification) {
                return TweetFollowNotificationCard(notification: notification);
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
