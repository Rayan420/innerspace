import 'package:shared_preferences/shared_preferences.dart';

class Preference {
// a function to check if the app is bneing launched for the first time
  Future<bool> checkFirstTimeLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time_launch') ?? true;

    if (isFirstTime) {
      // Set the flag to false after the first launch
      await prefs.setBool('first_time_launch', false);
    }

    return isFirstTime;
  }
}
