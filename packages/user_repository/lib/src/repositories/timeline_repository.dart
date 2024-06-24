import 'dart:async';
import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/src/utils/backend_urls.dart';

class TimelineRepository {
  final String _baseUrl = BackendUrls.developmentBaseUrl;
  final UserRepository _userRepository;
  StreamController<List<Post>> _timelineController =
      StreamController<List<Post>>.broadcast();
  final _timeline = <Post>[];

  Stream<List<Post>> get timelineStream => _timelineController.stream;

  TimelineRepository({required UserRepository userRepository})
      : _userRepository = userRepository;

  // sse subscription
  void subscribeToTimelineSSE(int userId, String accessToken) {
    final url = '$_baseUrl/timeline/subscribe/$userId';

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

            // Check the event type and handle accordingly
            if (event.event == "initialData") {
              // Initial data load
              final initialData =
                  data.map<Post>((json) => Post.fromJson(json)).toList();
              print('Initial data: $initialData'); // Debug log
              _timeline.insertAll(0, initialData);
              _timelineController.add(_timeline);
            } else if (event.event == "newPost") {
              // Handle new post event
              final newPost = Post.fromJson(data);
              _timeline.insert(0, newPost);
              _timelineController.add(_timeline);
              print('New post added to timeline: $newPost');
            }
            print('Timeline: $_timeline');
          } catch (e) {
            print('Error: ' + e.toString());
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
    _timeline.clear();
    _timelineController.add(_timeline); // Notify listeners of the cleared list
  }

  // Create a post, send an audio file
  Future<bool> createPost({required String audioFilePath}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return false;
    }

    print('Creating post...');
    print('Audio file path: $audioFilePath');

    // Add the user id as a query parameter
    final endpointUrl = '$_baseUrl/timeline/post';
    final uri =
        Uri.parse('$endpointUrl?userId=${_userRepository.user!.userId}');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromPath('file', audioFilePath));

    final response = await request.send();
    if (response.statusCode == 201) {
      print('Post created successfully');
      return true;
    } else {
      print('Failed to create post. Status code: ${response.statusCode}');
      return false;
    }
  }
}
