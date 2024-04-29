import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfig {
  static SharedPreferences? _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    // check if welcome key exists
  }

  static Future<void> saveWelcome(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static bool? getWelcome(String key) {
    return _preferences?.getBool(key);
  }
}
