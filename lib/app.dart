import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/app_view.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  final String flavor;
  final UserRepository userRepository;

  const App(this.userRepository, {Key? key, required this.flavor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(userRepository: userRepository),
      // ignore: prefer_const_constructors
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (context) => InternetBloc(),
          ),
        ],
        child: AppView(
          flavor: flavor,
        ),
      ),
    );
  }
}
