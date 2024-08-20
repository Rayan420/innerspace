import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/notifications.dart';
import 'package:user_repository/src/utils/backend_urls.dart';
import 'package:flutter/foundation.dart';

class NotificationRepository {
  final _notifications = <Notifications>[];
  final ValueNotifier<List<Notifications>> _notificationsNotifier =
      ValueNotifier([]);
  ValueNotifier<List<Notifications>> get notificationsNotifier =>
      _notificationsNotifier;

  final String _baseUrl = BackendUrls.developmentBaseUrl;
  final UserRepository _userRepository;

  NotificationRepository({required UserRepository userRepository})
      : _userRepository = userRepository {
    // Emit initial empty state
    _notificationsNotifier.value = _notifications;
  }

  void subscribeToNotificationSSE(int userId, String accessToken) {
    final url = '$_baseUrl/notifications/subscribe/$userId';

    SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: url,
      header: {
        "Authorization": "Bearer $accessToken",
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    ).listen(
      (event) {
        // print('event id: ${event.id}'); // Debug log
        // print('event event: ${event.event}'); // Debug log
        if (event.data != null && event.event != null) {
          try {
            final data = jsonDecode(event.data!);
            print('Received data: $data'); // Debug log

            // Handle initial data load

            if (event.event == 'initialData') {
              final newNotifications = data
                  .map<Notifications>((json) => _mapJsonToNotification(json))
                  .toList();
              _notifications.insertAll(0, newNotifications);
              _notificationsNotifier.value = List.from(_notifications);
              return; // Return early to avoid processing initial data for user repository updates
            }

            // Handle subsequent new notifications
            if (event.event == 'newNotification') {
              final notification = _mapJsonToNotification(data);
              if (notification is UnFollowNotification) {
                // print(
                //     'Handling UNFOLLOW notification: $notification'); // Debug log
                _userRepository.loadUserData();
                // Skip adding UNFOLLOW notification to the list
                return;
              }
              _notifications.insert(0, notification);
              _notificationsNotifier.value =
                  List.from(_notifications); // Update notifications list
              _userRepository.loadUserData();
            }
          } catch (e) {
            print('Error parsing event data: $e');
          }
        }
      },
      onError: (error) {
        print('Error: ' + error.toString());
      },
      onDone: () {
        print('Done!');
        // Cleanup the connection
        unsubscribeFromSSE();
      },
    );
  }

  // Cleanup the connection
  void unsubscribeFromSSE() {
    SSEClient.unsubscribeFromSSE();
    // Cleanup the notifications list
    _notifications.clear();
    _notificationsNotifier.value =
        List.from(_notifications); // Reset notifier value
  }

  Notifications _mapJsonToNotification(Map<String, dynamic> json) {
    final notificationType = json['notificationType'];
    // print('Mapping notification type: $notificationType'); // Debug log
    switch (notificationType) {
      case 'FOLLOW':
        return FollowNotification.fromJson(json);
      case 'UPVOTE':
        return LikeNotification.fromJson(json);
      case 'DOWNVOTE':
        return LikeNotification.fromJson(json);
      case 'UNFOLLOW':
        return UnFollowNotification.fromJson(json);
      default:
        return Notifications.fromJson(json);
    }
  }
}
