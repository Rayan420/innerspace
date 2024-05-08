import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:innerspace/constants/image_functions.dart';

class AvatarList extends StatelessWidget {
  final Function(Uint8List) onAvatarSelected;

  const AvatarList({super.key, required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          12,
          (index) => GestureDetector(
            onTap: () async {
              final imageBytes = await getImageBytes(
                  index < 6 ? 'man' : 'woman', index % 6 + 1);
              onAvatarSelected(imageBytes);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    // Removed `const` to allow dynamic image loading
                    image: AssetImage(
                      getImagePath(index < 6 ? 'man' : 'woman', index % 6 + 1),
                    ),
                  ),
                ), // Updated to call getImagePath
              ),
            ),
          ),
        ),
      ),
    );
  }
}
