import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/app_view.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/password_reset_bloc/password_reset_bloc.dart';
import 'package:user_repository/data.dart';

class App extends StatelessWidget {
  final String flavor;
  final UserRepository userRepository;
  final AuthenticationRepository authRepository;
  final NotificationRepository notificationRepository;
  final TimelineRepository timelineRepository;
  const App({
    super.key,
    required this.flavor,
    required this.userRepository,
    required this.authRepository,
    required this.notificationRepository,
    required this.timelineRepository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
        authenticationRepository: authRepository,
        userRepo: userRepository,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (context) => InternetBloc(),
          ),
          BlocProvider<PasswordResetBloc>(
            create: (context) => PasswordResetBloc(
              authRepository: context.read<AuthenticationBloc>().authRepository,
            ),
          ),
        ],
        child: AppView(
          flavor: flavor,
          notificationRepository: notificationRepository,
          timelineRepository: timelineRepository,
        ),
      ),
    );
  }
}
