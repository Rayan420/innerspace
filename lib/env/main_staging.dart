import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:innerspace/config/backedn_urls.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesConfig.initialize();
  UserRepository userRepo = UserRepository(baseUrl: BackendUrls.development);

  runApp(App(
    flavor: 'staging',
    userRepo,
  ));
}
