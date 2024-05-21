import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';

class AudioPlayerView extends StatelessWidget {
  final String audioPath;
  final VoidCallback onPost;
  final VoidCallback onCancel;
  final bool isDarkMode;

  const AudioPlayerView({
    Key? key,
    required this.audioPath,
    required this.onPost,
    required this.onCancel,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode ? tWhiteColor : tSecondaryColor,
              ),
              onPressed: onCancel,
              child: Text(
                'Cancel',
                style: TextStyle(color: isDarkMode ? tBlackColor : tWhiteColor),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: isDarkMode ? tWhiteColor : tSecondaryColor,
              ),
              child: Text(
                'Post',
                style: TextStyle(color: isDarkMode ? tBlackColor : tWhiteColor),
              ),
              onPressed: onPost,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage('assets/images/profile1.png'),
          backgroundColor: Colors.grey.shade200,
        ),
        const Text(
          'Listen to your recording',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: const AssetImage('assets/images/profile1.png'),
            ),
            title: Text('Recording'),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow, color: tPrimaryColor),
              onPressed: () {
                // Implement audio play logic here
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Post to: '),
            DropdownButton<String>(
              items: <String>['Timeline', 'Story'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ],
        ),
      ],
    );
  }
}
