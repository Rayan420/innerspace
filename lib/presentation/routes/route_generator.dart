// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/password_reset_bloc/password_reset_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/presentation/routes/nav_bar.dart';
import 'package:innerspace/presentation/screens/authentication/login/login_screen.dart';
import 'package:innerspace/presentation/screens/authentication/reset_password/forgot_password.dart';
import 'package:innerspace/presentation/screens/authentication/signup/profile_registration.dart';
import 'package:innerspace/presentation/screens/authentication/signup/signup_screen.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/splash.dart';
import 'package:innerspace/presentation/screens/welcome/welcome.dart';
import 'package:innerspace/presentation/screens/welcome/on_boarding_screen.dart';
import 'package:user_repository/data.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => NavigationScreen(
                  userRepository: args as UserRepository,
                  notificationRepository: args as NotificationRepository,
                  timelineRepository: args as TimelineRepository,
                ));
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PasswordResetBloc>(
            create: (context) => PasswordResetBloc(
                authRepository:
                    context.read<AuthenticationBloc>().authRepository),
            child: const ForgotPassword(),
          ),
        );

      case '/login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(
                    authRepository:
                        context.read<AuthenticationBloc>().authRepository,
                  ),
                  child: const LogIn(),
                ));
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              authRepository: context.read<AuthenticationBloc>().authRepository,
            ),
            child: const SignUp(),
          ),
        );
      case '/profile-setup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              authRepository: context.read<AuthenticationBloc>().authRepository,
            ),
            child: ProfileSetup(),
          ),
        );
      // case '/forgot-password':
      //   return MaterialPageRoute(builder: (_) => ForgotPassword());
      // case '/profile':
      //   return MaterialPageRoute(builder: (_) => Profile());
      // case '/settings':
      //   return MaterialPageRoute(builder: (_) => Settings());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
