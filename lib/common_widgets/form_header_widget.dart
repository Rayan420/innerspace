// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
  });

  final String? image;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null) // Check if image is provided
          Image(
            image: AssetImage(image!),
            height: size.height * 0.2,
          ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(subtitle, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
