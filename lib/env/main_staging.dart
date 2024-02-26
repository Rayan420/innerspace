import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(App(
    flavor: 'staging',
    FirebaseUserRepo(),
  ));
}
