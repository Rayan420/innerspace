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
}
