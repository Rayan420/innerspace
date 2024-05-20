import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:innerspace/config/backedn_urls.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:innerspace/config/simple_bloc_observer.dart';
import 'package:user_repository/data.dart';

void main() async {
  // Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize UserRepository and load user data
  UserRepository userRepository = UserRepository();

  // Initialize AuthenticationRepository
  AuthenticationRepository authRepository = AuthenticationRepository(
    baseUrl: BackendUrls.development,
    userRepository: userRepository,
  );

  SharedPreferencesConfig.initialize();

  // Initialize the Bloc observer
  Bloc.observer = SimpleBlocObserver();
  // Run the app
  runApp(App(
    flavor: 'development',
    userRepository: userRepository,
    authRepository: authRepository,
  ));
}
