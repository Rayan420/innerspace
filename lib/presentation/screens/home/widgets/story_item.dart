import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final Map<String, dynamic> storyData;
  final VoidCallback onTap;

  const StoryItem({
    required this.storyData,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 3.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(storyData['profileImageUrl']),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              storyData['userName'],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
