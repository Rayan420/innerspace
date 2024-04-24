// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/password_reset_bloc/password_reset_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/presentation/screens/authentication/login/login_screen.dart';
import 'package:innerspace/presentation/screens/authentication/reset_password/forgot_password.dart';
import 'package:innerspace/presentation/screens/authentication/signup/signup_screen.dart';
import 'package:innerspace/presentation/screens/welcome/welcome.dart';
import 'package:innerspace/presentation/screens/home/home_screen.dart';
import 'package:innerspace/presentation/screens/welcome/on_boarding_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case '/forgot-password':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PasswordResetBloc>(
            create: (context) => PasswordResetBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository),
            child: const ForgotPassword(),
          ),
        );

      case '/login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: const LogIn(),
                ));
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
            child: const SignUp(),
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
