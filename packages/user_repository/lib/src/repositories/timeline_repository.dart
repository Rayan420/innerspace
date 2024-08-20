import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/data.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/src/utils/backend_urls.dart';
import 'package:user_repository/src/utils/converters.dart';

class TimelineRepository {
  final String _baseUrl = BackendUrls.developmentBaseUrl;
  final UserRepository _userRepository;
  final StreamController<Post> _newPostController =
      StreamController<Post>.broadcast();
  final StreamController<List<Post>> _initialPostsController =
      StreamController<List<Post>>.broadcast();

  final StreamController<List<Post>> _ownPostsController =
      StreamController<List<Post>>.broadcast();

  Stream<Post> get newPostStream => _newPostController.stream;
  Stream<List<Post>> get initialPostsStream => _initialPostsController.stream;
  Stream<List<Post>> get ownPostsStream => _ownPostsController.stream;

  TimelineRepository({required UserRepository userRepository})
      : _userRepository = userRepository;

  // sse subscription
  void subscribeToTimelineSSE() async {
    final url = '$_baseUrl/timeline/subscribe/${_userRepository.user!.userId}';
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
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
              _initialPostsController.add(initialData);
              print('Initial data: $initialData');
            } else if (event.event == "newPost") {
              // Handle new post event
              final newPost = Post.fromJson(data);
              _newPostController.add(newPost);
            }
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

  Future<void> vote(String voteType, int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final url =
        '$_baseUrl/timeline/$voteType/$postId/${_userRepository.user!.userId}';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Vote updated successfully');
    } else {
      print('Failed to update vote. Status code: ${response.statusCode}');
    }
  }

  // load the user;s own posts
  Future<List<Post>> loadOwnPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return [];
    }

    final url = '$_baseUrl/timeline/${_userRepository.user!.userId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = data.map<Post>((json) => Post.fromJson(json)).toList();
      print('Own posts: $posts');
      _ownPostsController.add(posts);
      return posts;
    } else {
      print('Failed to load posts. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<List<Post>> loadUserPosts(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return [];
    }

    final url = '$_baseUrl/timeline/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = data.map<Post>((json) => Post.fromJson(json)).toList();
      print('Own posts: $posts');
      _ownPostsController.add(posts);
      return posts;
    } else {
      print('Failed to load posts. Status code: ${response.statusCode}');
      return [];
    }
  }

  // Cleanup the connection
  void unsubscribeFromSSE() {
    SSEClient.unsubscribeFromSSE();
    _newPostController.close();
    _initialPostsController.close();
  }

  // Create a post, send an audio file
  Future<bool> createPost(
      {required String audioFilePath, required int duration}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return false;
    }
    File file = File(audioFilePath);

    final byte = await fileToByteData(file);

    final uintFile = byteDataToUint8List(byte);
    print("file size: ${uintFile.lengthInBytes}");
    print("file type: ${uintFile.runtimeType}");

    print('Creating post...');
    print('Audio file path: $audioFilePath');
    print('Duration: $duration');

    // Add the user id as a query parameter
    final endpointUrl = '$_baseUrl/timeline/post';
    final uri =
        Uri.parse('$endpointUrl?userId=${_userRepository.user!.userId}');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files.add(await http.MultipartFile.fromBytes(
        'file',
        uintFile,
        filename: file.path.split('/').last,
        contentType: file.path.endsWith('.m4a')
            ? MediaType('audio', 'x-m4a')
            : MediaType('audio', 'mpeg'),
      ));
    request.fields['duration'] = duration.toString();

    final response = await request.send();
    if (response.statusCode == 201) {
      print('Post created successfully');
      loadOwnPosts();
      return true;
    } else {
      print('Failed to create post. Status code: ${response.statusCode}');
      return false;
    }
  }
}
