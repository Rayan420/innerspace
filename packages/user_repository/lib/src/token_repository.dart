import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:user_repository/user_repository.dart';

class UserDataStorage {
  final String _userDataFilePath;

  UserDataStorage(this._userDataFilePath);

  // Method to save user data to storage
  Future<void> saveUserData(User user) async {
    final file = File('$_userDataFilePath/user_data.json');
    await file.writeAsString(json.encode(user.toJson()));
  }

  // Method to retrieve user data from storage
  Future<User?> getUserData() async {
    try {
      final file = File('$_userDataFilePath/user_data.json');
      if (await file.exists()) {
        final userDataJson = await file.readAsString();
        return User.fromJson(json.decode(userDataJson));
      }
      return null;
    } catch (e) {
      log('Failed to retrieve user data: $e');
      return null;
    }
  }

  // Method to update user data in storage
  Future<void> updateUserData(User user) async {
    await saveUserData(user);
  }

  // Method to check if user data exists in storage
  bool userDataExists() {
    final file = File('$_userDataFilePath/user_data.json');
    return file.existsSync();
  }

  // Method to delete user data from storage
  Future<void> deleteUserData() async {
    final file = File('$_userDataFilePath/user_data.json');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
