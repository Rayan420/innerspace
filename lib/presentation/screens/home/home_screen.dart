// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'story_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded user information and stories
    final List<Map<String, dynamic>> stories = [
      {
        'userName': 'John Doe',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      {
        'userName': 'Jane Smith',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
        'audioUrl': 'https://cdn.pixabay.com/download/audio/2023/09/08/audio_b4bd5dcd5f.mp3?filename=mysterious-sci-fi-30-sec-background-music-165790.mp3',
      },
      {
        'userName': 'Alice Johnson',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      },
      {
        'userName': 'Bob Brown',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      },
      {
        'userName': 'Charlie Green',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
        'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: const [
              SizedBox(width: 15),
              Text(
                'Innerspace',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stories section
          Container(
            height: 120,
            child: ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: stories.length,
  itemBuilder: (context, index) {
    final storyData = stories[index]; // Use storyData instead of story
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StoryScreen(stories: stories, initialIndex: index),
        ),
      ),
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
                  backgroundImage: NetworkImage(storyData['profileImageUrl']), // Use storyData here
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              storyData['userName'], // Use storyData here
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  },
),

          ),
        ],
      ),
    );
  }
}
