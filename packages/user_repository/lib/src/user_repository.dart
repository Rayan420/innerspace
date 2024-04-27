import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/token_repository.dart';

class UserRepository {
  final _controller = StreamController<User?>(); // Stream of user data
  late UserDataStorage _userDataStorage; // User data storage

  final _httpClient = HttpClient();
  final String _baseUrl;

  UserRepository({required String baseUrl}) : _baseUrl = baseUrl {
    _userDataStorage = UserDataStorage('');
    // Initialize user data storage
    _initStorage();
  }

  // STREAM
  Stream<User?> get userStream => _controller.stream;

  // Method to initialize storage
  Future<void> _initStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    _userDataStorage = UserDataStorage(directory.path);
  }

  // Method to load user data from storage
  Future<void> loadUserData() async {
    final userExists = _userDataStorage.userDataExists();
    if (userExists) {
      final user = await _userDataStorage.getUserData();
      _controller.add(user); // Update user data stream
    }
  }

  // Method to save user data to storage
  Future<void> saveUserData(User user) async {
    await _userDataStorage.saveUserData(user);
    _controller.add(user); // Update user data stream
  }

  // Method to check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _userDataStorage.userDataExists();
  }

  // Method to sign up
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final responseData = await _sendRequest(
        '$_baseUrl/auth/register',
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(responseData['user']);
      await saveUserData(user); // Save user data to storage
    } catch (e) {
      log('Failed to sign up: $e');
      rethrow;
    }
  }

  // Method to log in
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final responseData = await _sendRequest(
        '$_baseUrl/auth/login',
        body: {
          'username': username,
          'password': password,
        },
      );

      final user = User.fromJson(responseData['user']);
      await saveUserData(user); // Save user data to storage
    } catch (e) {
      log('Failed to log in: $e');
      rethrow;
    }
  }

  // Method to log out
  Future<void> logOut() async {
    await _userDataStorage.deleteUserData(); // Delete user data from storage
    _controller.add(null); // Clear user data
  }

  // Method to send HTTP request and handle response
  Future<Map<String, dynamic>> _sendRequest(String url,
      {Map<String, String>? headers, Map<String, String>? body}) async {
    final request = await _httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    headers?.forEach((key, value) => request.headers.set(key, value));
    request.write(json.encode(body));
    final response = await request.close();
    if (response.statusCode != 200) {
      throw Exception('Failed to perform request: ${response.statusCode}');
    }
    return json.decode(await response.transform(utf8.decoder).join());
  }
}
