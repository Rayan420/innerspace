// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/config/route_generator.dart';
import 'package:innerspace/screens/home/home_screen.dart';
import 'package:innerspace/screens/onboarding/on_boarding_screen.dart';
import 'package:innerspace/screens/authentication/welcome.dart';
import 'package:innerspace/theme/theme.dart';

class AppView extends StatelessWidget {
  final bool hasBoarded;
  final String flavor;

  const AppView({Key? key, required this.hasBoarded, required this.flavor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: flavor == 'development',
        title: 'InnerSpace',
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: !hasBoarded
            ? const OnBoardingScreen()
            : BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return BlocProvider(
                    create: (context) => SignInBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                    child: const HomeScreen(),
                  );
                } else {
                  return const WelcomeScreen2();
                }
              }));
  }
}
