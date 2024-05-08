import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:innerspace/config/backedn_urls.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:innerspace/config/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  // Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize userr repository
  UserRepository userRepo = UserRepository(baseUrl: BackendUrls.development);
  userRepo.loadUserData();

  SharedPreferencesConfig.initialize();
  // request permission to use gallery and microphone

  // Initialize the Bloc observer
  Bloc.observer = SimpleBlocObserver();
  // Run the app
  runApp(App(
    flavor: 'development',
    userRepo,
  ));
}
