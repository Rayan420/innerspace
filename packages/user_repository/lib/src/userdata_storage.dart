import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class UserDataStorage {
  final String _userDataFilePath;

  UserDataStorage(this._userDataFilePath);

  // Method to save user data to storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final file = File('$_userDataFilePath/user_data.json');
    await file.writeAsString(json.encode(userData));
  }

  // Method to retrieve user data from storage
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final file = File('$_userDataFilePath/user_data.json');
      if (await file.exists()) {
        final userDataJson = await file.readAsString();
        return json.decode(userDataJson);
      }
      return {};
    } catch (e) {
      log('Failed to retrieve user data: $e');
      return {};
    }
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
