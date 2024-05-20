import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  User? user;
  final _controller =
      StreamController<User?>.broadcast(); // Stream of user data

  UserRepository() {
    _initStorage();
  }

  // Stream of user data
  Stream<User?> get userStream => _controller.stream;

  // Method to initialize storage
  Future<void> _initStorage() async {
    await loadUserData();
  }

  // Method to load user data from storage
  Future<User?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = json.decode(userDataString) as Map<String, dynamic>;
      user = User.fromJson(userData);
      _controller.add(user); // Update user data stream
      return user;
    } else {
      _controller.add(null);
    }
    return null;
  }

  // Method to save user data to storage
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    user = user;
    await prefs.setString('userData', json.encode(user.toJson()));
    _controller.add(user); // Update user data stream
  }

  // Method to clear user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    _controller.add(null); // Clear user data
  }

  // Method to update specific user data
  Future<void> updateUserField(String fieldName, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      final userJson = user!.toJson();
      userJson[fieldName] = value;
      user = User.fromJson(userJson);
      await prefs.setString('userData', json.encode(userJson));
      _controller.add(user); // Update user data stream
    }
  }
}
