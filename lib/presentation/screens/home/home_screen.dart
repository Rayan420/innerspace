// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      {
        'userName': 'Jane Smith',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
        'audioUrl':
            'https://cdn.pixabay.com/download/audio/2023/09/08/audio_b4bd5dcd5f.mp3?filename=mysterious-sci-fi-30-sec-background-music-165790.mp3',
      },
      {
        'userName': 'Alice Johnson',
        'profileImageUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      },
      {
        'userName': 'Bob Brown',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      },
      {
        'userName': 'Charlie Green',
        'profileImageUrl': 'https://randomuser.me/api/portraits/men/3.jpg',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Innerspace',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Stories section
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return StoryItem(
                  storyData: stories[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryScreen(stories: stories, initialIndex: index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 290,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1c1c1c),
              border: Border(
                top: BorderSide(color: Color.fromARGB(255, 139, 129, 129), width: 0.2),
                bottom: BorderSide(color: Color.fromARGB(255, 139, 129, 129), width: 0.2),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: const [
                    SizedBox(width: 15),
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: AssetImage('assets/images/zendaya.jpg'),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Aarav Sharma',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(width: 120,),
                    Text('10 min ago', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  width: 330,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFafcdfa),
                        Color(0xFF294266), // You can add more colors if needed
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        
                        bottom: 35,
                        right:120,
                        child: CircleAvatar(
                      radius: 47,
                      backgroundImage: AssetImage('assets/images/zendaya.jpg'),
                    ),),
                     Positioned(
                        
                        bottom: 10,
                        left:20,
                        child: Text('1:40'),
                    ),
                    Positioned(
                        
                        bottom: 8,
                        left:55,
                        child: GestureDetector(

                          child: Image.asset('assets/images/audio.png',width: 25,height: 25,color: Color.fromARGB(255, 210, 209, 209),),
                        ),
                    ),
                    Positioned(
                        
                        bottom: 10,
                        right:20,
                        child: Text('Innerspace',style: TextStyle(fontSize: 14),)
                        ),
                    Positioned(
                      bottom: 62,
                      right: 148,
                      child: Opacity(
                        opacity: 0.5, // Adjust the opacity value (0.0 to 1.0) to make the image transparent
                        child: Image.asset(
                          'assets/images/playbutton.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    )

                    
                    
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    UpvoteDownvoteButton(),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

class UpvoteDownvoteButton extends StatefulWidget {
  @override
  _UpvoteDownvoteButtonState createState() => _UpvoteDownvoteButtonState();
}

class _UpvoteDownvoteButtonState extends State<UpvoteDownvoteButton> {
  int count = 0;
  bool isUpvoted = false;
  bool isDownvoted = false;

  void toggleUpvote() {
    setState(() {
      if (!isUpvoted) {
        count++;
        isUpvoted = true;
      } else {
        count--;
        isUpvoted = false;
      }
      isDownvoted = false; // Reset downvote
    });
  }

  void toggleDownvote() {
    setState(() {
      if (!isDownvoted) {
        count--;
        isDownvoted = true;
      } else {
        count++;
        isDownvoted = false;
      }
      isUpvoted = false; // Reset upvote
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: toggleUpvote,
          child: Image.asset(
            isUpvoted ? 'assets/images/upvoteClicked.png' : 'assets/images/upvote.png',
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(width: 5),
        Text('$count'),
        SizedBox(width: 10),
        Container(
          width: 0.4,
          height: 25,
          color: Colors.white,
          ),
          SizedBox(width: 10,),
        GestureDetector(
          onTap: toggleDownvote,
          child: Image.asset(
            isDownvoted ? 'assets/images/downvoteClicked.png' : 'assets/images/downvote.png',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
