import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innerspace/config/app_preference.dart';
import 'package:innerspace/config/firebase_options_production.dart';
import 'package:innerspace/config/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
// Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the app is launched for the first time
  bool isFirstTime = await Preference().checkFirstTimeLaunch();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize the Bloc observer
  Bloc.observer = SimpleBlocObserver();

// Run the app
  runApp(App(
    flavor: 'production',
    FirebaseUserRepo(),
    isFirstTime: isFirstTime,
  ));
}
