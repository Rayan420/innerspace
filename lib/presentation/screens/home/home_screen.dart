// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, you are In !'),
      ),
    );
  }
}
