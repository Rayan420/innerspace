import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';

class GlowingAvatar extends StatelessWidget {
  const GlowingAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowCount: 3,
      glowRadiusFactor: 0.1,
      glowColor: tPrimaryColor,
      duration: const Duration(milliseconds: 1500),
      repeat: true,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/images/profile1.png'),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
