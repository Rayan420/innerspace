// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:innerspace/presentation/routes/nav_bar.dart';
import 'package:innerspace/presentation/routes/route_generator.dart';
import 'package:innerspace/presentation/screens/authentication/login/login_screen.dart';
import 'package:innerspace/presentation/screens/splash.dart';
import 'package:innerspace/constants/theme/theme.dart';
import 'package:innerspace/presentation/screens/welcome/welcome.dart';
import 'package:user_repository/data.dart';

class AppView extends StatelessWidget {
  final String flavor;

  const AppView({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: flavor == 'development',
      title: 'InnerSpace',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            // Check if the welcome screen should be shown
            final bool showWelcomeScreen =
                SharedPreferencesConfig.getWelcome("loadWelcome") == null ||
                    SharedPreferencesConfig.getWelcome("loadWelcome") == true;

            // Check if the authentication state is unknown
            final bool unknownAuthStatus =
                state.status == AuthenticationStatus.unknown;

            // Show the SplashScreen if welcome screen is needed or authentication status is unknown
            if (unknownAuthStatus) {
              return SplashScreen();
            } else if (showWelcomeScreen) {
              return WelcomeScreen();
            } else {
              // Once the authentication state is determined, show the appropriate screen
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  return NavigationScreen(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  );
                case AuthenticationStatus.unauthenticated:
                  return BlocProvider(
                      create: (context) {
                        return SignInBloc(
                          authRepository:
                              context.read<AuthenticationBloc>().authRepository,
                        );
                      },
                      child: LogIn());
                default:
                  // This should not happen, but if it does, return SplashScreen
                  return SplashScreen();
              }
            }
          },
        );
      },
    );
  }
}
