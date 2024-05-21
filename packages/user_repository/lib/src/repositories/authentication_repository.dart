// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/src/models/models.dart';
import 'user_repository.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationRepository {
  Token? _token;
  final UserRepository _userRepository;
  final _controller = StreamController<
      AuthenticationStatus>.broadcast(); // Stream of auth status
  final _httpClient = http.Client();
  final String _baseUrl;

  AuthenticationRepository({
    required String baseUrl,
    required UserRepository userRepository,
  })  : _baseUrl = baseUrl,
        _userRepository = userRepository {
    _initAuth();
  }

  Stream<AuthenticationStatus> get status => _controller.stream;

  void _initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    // print(accessToken);
    // print(refreshToken);
    if (accessToken != null && refreshToken != null) {
      _token = Token(access: accessToken, refresh: refreshToken);
      // refreesh the token, if refreshed token is not available, then the user is unauthenticated
      bool isRefreshed = await _refreshToken();
      if (isRefreshed) {
        _controller.add(AuthenticationStatus.authenticated);
      }
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> _saveTokens(Token token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token.access);
    await prefs.setString('refreshToken', token.refresh);
  }

  Future<void> _saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  Future<void> _saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final responseData = await _sendRequest(
        '$_baseUrl/auth/register',
        headers: {'Content-Type': 'application/json'},
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(responseData['user']);
      _token = Token.fromJson(responseData['tokens']);
      await _userRepository.saveUserData(user); // Save user data to storage
      await _saveTokens(_token!);
      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      log('Failed to sign up: $e');
      rethrow;
    }
  }

// modify this so that it accepts a File object instead of a Uint8List
  Future<void> signUpComplete({
    required String bio,
    required Uint8List avatar,
    required String dob,
  }) async {
    try {
      final user = await _userRepository.userStream.first;
      if (user == null) throw Exception('User is not available');

      // send multipart request to complete sign up
      final responseData = await sendMultipartRequest(
        '$_baseUrl/auth/register/${user.username}/complete',
        headers: {
          'Authorization': 'Bearer ${_token!.access}',
          'Content-Type': 'multipart/form-data',
        },
        body: {
          'bio': bio,
          'dob': dob,
        },
        files: [
          http.MultipartFile.fromBytes(
            'avatar',
            avatar,
            filename: 'avatar.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        ],
      );

      if (responseData['user'] != null && responseData['tokens'] != null) {
        final updatedUser = User.fromJson(responseData['user']);
        _token = Token.fromJson(responseData['tokens']);
        await _userRepository.saveUserData(updatedUser);
        await _saveTokens(_token!);
      } else {
        throw Exception('Failed to perform request: Response data is null');
      }
    } catch (e) {
      log('Failed to complete sign up: $e');
      rethrow;
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    try {
      final responseData = await _sendRequest(
        '$_baseUrl/auth/login',
        headers: {'Content-Type': 'application/json'},
        body: {
          'username': username,
          'password': password,
        },
      );

      final user = User.fromJson(responseData['user']);
      _token = Token.fromJson(responseData['tokens']);
      await _userRepository.saveUserData(user); // Save user data to storage
      await _saveTokens(_token!);
      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      log('Failed to log in: $e');
      _controller.add(AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      final user = await _userRepository.userStream.first;
      if (user == null) throw Exception('User is not available');

      await _sendRequest(
        '$_baseUrl/auth/logout/${user.username}',
        headers: {
          'Authorization': 'Bearer ${_token!.access}',
        },
      );
      await _userRepository.clearUserData(); // Clear user data from storage
      await _clearToken();
      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      log('Failed to log out: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _sendRequest(
        '$_baseUrl/auth/forgot-password/$email/send',
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      log('Failed to reset password: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> confirmOtp(
      String email, String verifyCode) async {
    try {
      var url = Uri.parse('$_baseUrl/auth/forgot-password/$email/otp')
          .replace(queryParameters: {'verify': verifyCode});

      return await _sendRequest(
        url.toString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      log('Failed to confirm OTP: $e');
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String s, String t, String password) async {
    try {
      var url = Uri.parse('$_baseUrl/auth/forgot-password/$s/change');
      var requestBody = {
        'token': t,
        'password': password,
      };
      await _sendRequest(
        url.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: requestBody,
      );
    } catch (e) {
      log('Failed to reset password: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _sendRequest(String url,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final response = await _httpClient.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 401) {
      if (await _refreshToken()) {
        return _sendRequest(url,
            headers: headers, body: body); // Retry the request
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode != 200) {
      throw Exception('Failed to perform request: ${response.statusCode}');
    }
    return json.decode(response.body);
  }

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      // Create a multipart request
      final request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/auth/refresh/'))
            ..fields['Token'] = refreshToken;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        _controller.add(AuthenticationStatus.unauthenticated);
        return false;
      }

      final responseData = json.decode(response.body);

      String newToken =
          responseData['token']; // Directly accessing the token field

      await _saveAccessToken(newToken);
      return true;
    } catch (e) {
      log('Failed to refresh token: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> sendMultipartRequest(
    String url, {
    required Map<String, String> headers,
    required Map<String, String> body,
    List<http.MultipartFile>? files,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..fields.addAll(body);

    // Add files to the request if provided
    files?.forEach((file) {
      request.files.add(file);
    });

    final response = await request.send();
    if (response.statusCode == 401) {
      if (await _refreshToken()) {
        return sendMultipartRequest(
          url,
          headers: headers,
          body: body,
          files: files,
        );
      } else {
        _controller.add(AuthenticationStatus.unauthenticated);
        throw Exception('Failed to refresh token');
      }
    } else if (response.statusCode != 200) {
      throw Exception('Failed to perform request: ${response.statusCode}');
    }

    final responseBody = await response.stream.bytesToString();
    return json.decode(responseBody);
  }
}