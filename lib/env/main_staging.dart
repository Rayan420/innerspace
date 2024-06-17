import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:user_repository/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize UserRepository and load user data
  UserRepository userRepository = UserRepository();

  // initialize notification repository
  NotificationRepository notificationRepository = NotificationRepository(
    userRepository: userRepository,
  );

  // Initialize AuthenticationRepository
  AuthenticationRepository authRepository = AuthenticationRepository(
    userRepository: userRepository,
    notificationRepository: notificationRepository,
  );

  SharedPreferencesConfig.initialize();

  runApp(App(
    flavor: 'staging',
    userRepository: userRepository,
    authRepository: authRepository,
    notificationRepository: notificationRepository,
  ));
}
