import 'package:shared_preferences/shared_preferences.dart';

class Preference {
// a function to check if user has onboarded
  Future<bool> hasOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasOnboarded = prefs.getBool('has_onboarded') ?? false;
    return hasOnboarded;
  }

  // function to set onboarding status
  Future<bool> setOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('has_onboarded', true);
  }
}
