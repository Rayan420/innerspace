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

  void subscribeToSSE(int userId, String accessToken) {
    final url = '$_baseUrl/notifications/subscribe/$userId';

    bool initialDataLoaded = false; // Flag to differentiate initial data load

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
        if (event.data != null) {
          try {
            final data = jsonDecode(event.data!);

            if (!initialDataLoaded) {
              // Handle initial data load
              initialDataLoaded =
                  true; // Set the flag to true after initial data load
              if (data is List) {
                final newNotifications = data
                    .map<Notifications>((json) => _mapJsonToNotification(json))
                    .toList();
                _notifications.insertAll(0, newNotifications);
              }
              _notificationsNotifier.value = List.from(_notifications);
              return; // Return early to avoid processing initial data for user repository updates
            }

            // Handle subsequent new notifications
            if (data is Map<String, dynamic>) {
              final notification = _mapJsonToNotification(data);
              if (notification is UnFollowNotification) {
                print(
                    'Handling UNFOLLOW notification: $notification'); // Debug log
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
    print('Mapping notification type: $notificationType'); // Debug log
    switch (notificationType) {
      case 'FOLLOW':
        return FollowNotification.fromJson(json);
      case 'LIKE':
        return LikeNotification.fromJson(json);
      case 'UNFOLLOW':
        return UnFollowNotification.fromJson(json);
      default:
        return Notifications.fromJson(json);
    }
  }
}
