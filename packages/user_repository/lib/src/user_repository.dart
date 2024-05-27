import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/repositories/userdata_storage.dart';

class UserRepository {
  late Token _token;
  late User _user;

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
    loadUserData(); // Load user data from storage
  }

  // Method to load user data from storage
  Future<void> loadUserData() async {
    final userExists = _userDataStorage.userDataExists();
    if (userExists) {
      final userData = await _userDataStorage.getUserData();
      _user = User.fromJson(userData['user']);
      _token = Token.fromJson(userData['token']);
      _controller.add(_user); // Update user data stream
    }
  }

  // Method to save user data to storage
  Future<void> saveUserData() async {
    await _userDataStorage
        .saveUserData({'user': _user.toJson(), 'token': _token.toJson()});
    _controller.add(_user); // Update user data stream
  }

  // Method to check if user is authenticated
  Future<bool> isAuthenticated() async {
    return _userDataStorage.userDataExists();
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
      // Construct the URL with query parameters
      var url = Uri.parse('$_baseUrl/auth/forgot-password/$email/otp')
          .replace(queryParameters: {'verify': verifyCode});

      // Send the request
      return await _sendRequest(
        url.toString(),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      // Handle errors
      log('Failed to reset password: $e');
      // Rethrow the error
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String s, String t, String password) async {
    try {
      // Construct the URL with query parameters
      var url = Uri.parse('$_baseUrl/auth/forgot-password/$s/change');
      // Construct the request body
      var requestBody = {
        'token': t,
        'password': password // Encode the password as JSON string
      };
      // Send the request
      await _sendRequest(url.toString(),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: requestBody);
      // Process the response
      // ...
    } catch (e) {
      // Handle errors
      log('Failed to reset password: $e');
      // Rethrow the error
      rethrow;
    }
  }

  // Method to sign up
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
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password,
        },
      );

      _user = User.fromJson(responseData['user']);
      _token = Token.fromJson(responseData['tokens']);
      print(_token.access);
      await saveUserData(); // Save user data to storage
    } catch (e) {
      log('Failed to sign up: $e');
      rethrow;
    }
  }

  Future<void> signUpComplete({
    required String bio,
    required Uint8List avatar,
    required String dob,
  }) async {
    print('signUpComplete');

    try {
      final formattedDob = DateTime.parse(dob);
      final formattedDobString = DateFormat('yyyy-MM-dd').format(formattedDob);

      final responseData = await _sendMultipartRequest(
        '$_baseUrl/auth/register/${_user.username}',
        headers: {
          'Authorization': 'Bearer ${_token.access}',
          'Content-Type': 'multipart/form-data',
        },
        body: {
          'bio': bio,
          'dob': formattedDobString,
        },
        byteData: avatar,
        username: _user.username,
      );
      print(responseData);

      if (responseData != null &&
          responseData['user'] != null &&
          responseData['tokens'] != null) {
        _user = User.fromJson(responseData['user']);
        _token = Token.fromJson(responseData['tokens']);
        await saveUserData();
      } else {
        throw Exception('Failed to perform request: Response data is null');
      }
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

      _user = User.fromJson(responseData['user']);
      _token = Token.fromJson(responseData['tokens']);

      await saveUserData(); // Save user data to storage
    } catch (e) {
      log('Failed to log in: $e');
      rethrow;
    }
  }

  // Method to log out
  Future<void> logOut() async {
    try {
      await _sendRequest(
        '$_baseUrl/auth/logout/${_user.username}',
        headers: {
          'Authorization': 'Bearer ${_token.access}',
        },
      );
      await _userDataStorage.deleteUserData(); // Delete user data from storage
      _controller.add(null); // Clear user data
    } catch (e) {
      log('Failed to log out: $e');
      rethrow;
    }
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

  // method to send multipart request
  Future<Map<String, dynamic>> _sendMultipartRequest(String url,
      {Map<String, String>? headers,
      Map<String, String>? body,
      required Uint8List byteData,
      required String username}) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    headers?.forEach((key, value) => request.headers[key] = value);
    body?.forEach((key, value) => request.fields[key] = value);

    // Add the file to the request
    request.files.add(http.MultipartFile.fromBytes(
      'profile',
      byteData,
      filename: '$username.png',
    ));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to perform request: ${response.statusCode}');
    }
    return json.decode(await response.stream.bytesToString());
  }

  Future<File> byteDataToFile(ByteData byteData, String filename) async {
    final buffer = byteData.buffer;
    final tempDir = Directory.systemTemp;
    final tempPath = tempDir.path;
    final file = File('$tempPath/$filename');
    await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  ByteData uint8ListToByteData(Uint8List uint8List) {
    return ByteData.view(uint8List.buffer);
  }
}
