import 'dart:async';
import 'dart:convert'; // Import for jsonDecode
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:user_repository/src/models/notifications.dart';
import 'package:user_repository/src/utils/backedn_urls.dart';

class NotificationRepository {
  final _notifications = <Notifications>[];
  final _controller = StreamController<List<Notifications>>.broadcast();
  Stream<List<Notifications>> get notificationStream => _controller.stream;
  final String _baseUrl = BackendUrls.development;

  void subscribeToSSE(int userId, String accessToken) {
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
        print('Event: ${event.data}');
        if (event.data != null) {
          try {
            final data = jsonDecode(event.data!);

            if (data is List) {
              final newNotifications = data
                  .map<Notifications>((json) => _mapJsonToNotification(json))
                  .toList();
              _notifications.insertAll(
                  0, newNotifications); // Prepend to the list
            } else if (data is Map<String, dynamic>) {
              final notification = _mapJsonToNotification(data);
              
              _notifications.insert(0, notification); // Prepend to the list
            } else {
              print('Unexpected data format: ${event.data}');
            }

            // Send the updated list of notifications from newest to oldest
            _controller.add(_notifications);
          } catch (e) {
            print('Error parsing event data: $e');
          }
        } else {
          print('Received null event data');
        }
      },
      onError: (error) {
        print('Error: ' + error.toString());
      },
      onDone: () {
        print('Done!');
      },
    );
  }

  Notifications _mapJsonToNotification(Map<String, dynamic> json) {
    final notificationType = json['notificationType'];
    switch (notificationType) {
      case 'FOLLOW':
        return FollowNotification.fromJson(json);
      case 'LIKE':
        return LikeNotification.fromJson(json);
      default:
        return Notifications.fromJson(json);
    }
  }

  void dispose() {
    _controller.close();
  }
}
