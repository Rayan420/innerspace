// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/config/shared_preference_config.dart';
import 'package:innerspace/presentation/routes/route_generator.dart';
import 'package:innerspace/presentation/screens/home/home_screen.dart';
import 'package:innerspace/presentation/screens/welcome/welcome.dart';
import 'package:innerspace/constants/theme/theme.dart';

import 'presentation/screens/authentication/login/login_screen.dart';

class AppView extends StatelessWidget {
  final String flavor;

  const AppView({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    print(SharedPreferencesConfig.getWelcome("loadWelcome"));
    return MaterialApp(
        debugShowCheckedModeBanner: flavor == 'development',
        title: 'InnerSpace',
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: BlocBuilder<InternetBloc, InternetState>(
          builder: (context, state) {
            return SharedPreferencesConfig.getWelcome("loadWelcome") == null ||
                    SharedPreferencesConfig.getWelcome("loadWelcome") == true
                ? WelcomeScreen()
                : BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                    if (state.status == AuthenticationStatus.authenticated) {
                      return BlocProvider(
                        create: (context) => SignInBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository),
                        child: const HomeScreen(),
                      );
                    } else {
                      return BlocProvider(
                        create: (context) => SignInBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository),
                        child: const LogIn(),
                      );
                    }
                  });
          },
        ));
  }
}
