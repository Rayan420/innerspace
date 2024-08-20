import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:user_repository/src/utils/backend_urls.dart';

class UserRepository {
  User? user;
  final _controller = StreamController<User>.broadcast(); // Stream of user data
  final _httpClient = http.Client();
  final String _baseUrl = BackendUrls.developmentBaseUrl;

  UserRepository() {
    _initStorage();
  }

  Stream<User> get userStream => _controller.stream;

  Future<void> _initStorage() async {
    await loadUserData();
  }

  Future<User> fetchUserProfile() async {
    return user!;
  }

  Future<User?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    final accessToken = prefs.getString('accessToken');

    if (userDataString != null && accessToken != null) {
      final userId = json.decode(userDataString)['userId'];
      final responseData = await _httpClient.get(
        Uri.parse('$_baseUrl/user/load/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (responseData.statusCode == 200) {
        print(
            'User data loaded from server successfully: ${responseData.body}');
        final response = json.decode(responseData.body);

        // Check structure of response
        if (response.containsKey('user')) {
          final userJson = response['user'];
          final finalUser = User.fromJson(userJson);
          user = finalUser;
          print('User data converted to User object: ${finalUser.toJson()}');
          _controller.add(finalUser); // Update user data stream
          return user;
        } else {
          print('Error: "user" key not found in response');
        }
      } else {
        print(
            'Error: Failed to fetch user data, status code: ${responseData.statusCode}');
      }
    }
    return null;
  }

  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    this.user = user;
    final userData = {
      'userId': user.userId,
      'email': user.email,
    };
    await prefs.setString('userData', json.encode(userData));
    _controller.add(user); // Update user data stream
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    user = null;
    // _controller.add(null); // Clear user data stream
  }

  Future<void> updateUserField(String fieldName, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      final userJson = user!.toJson();
      userJson[fieldName] = value;
      user = User.fromJson(userJson);
      await prefs.setString('userData', json.encode(userJson));
      _controller.add(user!); // Update user data stream
    }
  }

  Future<void> followUnfollowUser(User followUser) async {
    final followed = LightweightUser(
        userId: followUser.userId,
        username: followUser.username,
        firstName: followUser.firstName!,
        lastName: followUser.lastName!);
    print("following/unfollowing user: $followed");
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final responseData = await _httpClient.post(
      Uri.parse('$_baseUrl/user/follow/${user!.userId}/${followed.userId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (responseData.statusCode == 200) {
      user!.following.contains(followed)
          ? user!.following.remove(followed)
          : user!.following.add(followed);
      user!.userProfile.followingCount = user!.following.length;
      _controller.add(user!); // Update user data stream
    } else {
      print(
          'Error: Failed to follow/unfollow user, status code: ${responseData.statusCode}');
    }
  }

  Future<void> followUnfollowUserFromNotif(
      int userId, String name, String username) async {
    // split name into first and last name
    final splitName = name.split(' ');

    final followed = LightweightUser(
        userId: userId,
        username: username,
        firstName: splitName[0],
        lastName: splitName[1]);
    print("following/unfollowing user: $followed");
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final responseData = await _httpClient.post(
      Uri.parse('$_baseUrl/user/follow/${user!.userId}/${followed.userId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (responseData.statusCode == 200) {
      user!.following.contains(followed)
          ? user!.following.remove(followed)
          : user!.following.add(followed);
      user!.userProfile.followingCount = user!.following.length;
      _controller.add(user!); // Update user data stream
    } else {
      print(
          'Error: Failed to follow/unfollow user, status code: ${responseData.statusCode}');
    }
  }

  Future<void> updateUserProfile(
      String f, String l, String b, Uint8List? pp, Uint8List? cp) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final request = http.MultipartRequest(
        'PUT', Uri.parse('$_baseUrl/profile/update/${user!.userId}'))
      ..headers['Authorization'] = 'Bearer $accessToken';

    request.fields['firstName'] = f;
    request.fields['lastName'] = l;
    request.fields['bio'] = b;

    if (pp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'profile', pp,
        filename: '${user!.username}.jpg',
        contentType: MediaType('image', 'jpeg'), // Specify content type here
      ));
    }

    if (cp != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'cover', cp,
        filename: 'coverPicture.jpg',
        contentType: MediaType('image', 'jpeg'), // Specify content type here
      ));
    }

    // Send the request here
    final response = await request.send();

    // Handle response as needed
    if (response.statusCode == 200) {
      // Handle success
      // decode the response
      final data = await response.stream.bytesToString();
      final userJson = json.decode(data);
      user!.firstName = userJson['firstName'];
      user!.lastName = userJson['lastName'];
      user!.userProfile.bio = userJson['bio'];
      user!.userProfile.profilePicture =
          BackendUrls.replaceLocalhost(userJson['profileImageUrl']);
      user!.userProfile.coverPicture =
          BackendUrls.replaceLocalhost(userJson['coverImageUrl']);
      print("THE UPDATED DATA FROM THE CALL IS: $userJson");
      _controller.add(user!);
      // update user data
      loadUserData();
    } else {
      // Handle error
    }
  }
}
