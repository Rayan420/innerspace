import 'package:flutter/material.dart';
import 'package:user_repository/data.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userRepository});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    String userEmail = userRepository.user!.email;
    return Center(
      child: Text('THIS IS THE PROFILE SCREEN OF ${userEmail}'),
    );
  }
}
