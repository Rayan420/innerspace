import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data.dart';
import '../utils/backedn_urls.dart';

class SearchRepository {
  final _controller = StreamController<List<User?>>.broadcast();
  Stream<List<User?>> get userStream => _controller.stream;

  final _httpClient = http.Client();
  final String _baseUrl = BackendUrls.development;
  Timer? _debounceTimer;
  final Map<String, List<User?>> _cache = {};

  Future<void> searchUser(String query) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_cache.containsKey(query)) {
        _controller.sink.add(_cache[query]!);
        return;
      }
      try {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken');
        print('access toke $accessToken');

        if (accessToken == null) {
          throw Exception('Access token is missing');
        }

        final response = await _httpClient.get(
          Uri.parse('$_baseUrl/user/search/$query'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
        if (response.statusCode == 200) {
          final List<dynamic> jsonData = jsonDecode(response.body);
          final List<User?> users =
              jsonData.map((data) => User.fromJson(data)).toList();
          _cache[query] = users;
          print('cache ${_cache.length}');
          print('first user ${users[0]}');
          _controller.sink.add(users);
        } else {
          throw Exception('Failed to load users');
        }
      } catch (e) {
        _controller.sink.addError('Failed to search users: $e');
      }
    });
  }

  Future<void> saveRecentSearch(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final recentSearches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.add(jsonEncode(user.toJson()));
    await prefs.setStringList('recentSearches', recentSearches);
  }

  Future<List<User>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final recentSearches = prefs.getStringList('recentSearches') ?? [];
    return recentSearches
        .map((search) => User.fromJson(jsonDecode(search)))
        .toList();
  }

  Future<void> deleteRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
  }

  void dispose() {
    _controller.close();
  }
}
