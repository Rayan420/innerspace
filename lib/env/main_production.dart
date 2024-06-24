import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:innerspace/config/simple_bloc_observer.dart';
import 'package:user_repository/data.dart';

void main() async {
// Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize UserRepository and load user data
  UserRepository userRepository = UserRepository();

  // initialize notification repository
// initialize notification repository
  NotificationRepository notificationRepository = NotificationRepository(
    userRepository: userRepository,
  );
  TimelineRepository timelineRepository =
      TimelineRepository(userRepository: userRepository);

  // Initialize AuthenticationRepository
  AuthenticationRepository authRepository = AuthenticationRepository(
    userRepository: userRepository,
    notificationRepository: notificationRepository,
    timelineRepository: timelineRepository,
  );

  // Initialize the Bloc observer
  Bloc.observer = SimpleBlocObserver();

// Run the app
  runApp(App(
    flavor: 'production',
    userRepository: userRepository,
    authRepository: authRepository,
    notificationRepository: notificationRepository,
    timelineRepository: timelineRepository,
  ));
}
