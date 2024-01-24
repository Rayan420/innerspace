import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/screens/home/home_screen.dart';
import 'package:innerspace/screens/auth/welcome_screen.dart';
import 'package:innerspace/theme.dart';

class AppView extends StatelessWidget {
  final String flavor;
  const AppView({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: flavor == 'development',
        title: 'InnerSpace',
        theme: darkTheme,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => SignInBloc(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository,
              ),
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        }));
  }
}
