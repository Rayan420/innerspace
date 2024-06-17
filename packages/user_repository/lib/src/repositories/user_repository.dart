import 'dart:async';
import 'dart:convert';
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

  // Stream of user data
  Stream<User> get userStream => _controller.stream;

  // Method to initialize storage
  Future<void> _initStorage() async {
    await loadUserData();
  }

  Future<User> fetchUserProfile() async {
    return user!;
  }

  // method to update user follower count and push to stream
  void updateUserFollowerCount() {
    user!.userProfile.followerCount++;
    _controller.add(user!);
  }

  // Method to load user data from storage
  Future<User?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    final accessToken = prefs.getString('accessToken');
    if (userDataString != null) {
      // send request to get user data
      final response = await _httpClient.get(
        Uri.parse(
            '$_baseUrl/user/load/${json.decode(userDataString)['userId']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final resUser = json.decode(response.body);
      user = User.fromJson(resUser['user']);
      return user;
    } else {
      // _controller.add(null);
    }
    return null;
  }

  // Method to save user data to storage
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    user = user;
    final userData = {
      'userId': user.userId,
      'email': user.email,
    };
    await prefs.setString('userData', json.encode(userData));
    _controller.add(user); // Update user data stream
  }

  // Method to clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    // _controller.add(null); // Clear user data
  }

  // Method to update specific user data
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
}
