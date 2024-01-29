import 'package:flutter/material.dart';
import 'package:innerspace/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innerspace/config/app_preference.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
   // Check if the app is launched for the first time
  bool hasBoarded = await Preference().hasOnboarded();
  runApp(App(flavor: 'staging', FirebaseUserRepo(), hasBoarded: hasBoarded,));
}
