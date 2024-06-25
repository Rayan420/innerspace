import 'package:flutter/material.dart';
import 'package:innerspace/presentation/screens/home/widgets/upvote_downvote_button.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/data.dart'; // Replace with your actual data model

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTapPlayPause;
  final bool isPlaying;
  final bool isLoading;

  const PostCard({
    required this.post,
    required this.onTapPlayPause,
    required this.isPlaying,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1c1c1c),
        border: Border(
          top:
              BorderSide(color: Color.fromARGB(255, 139, 129, 129), width: 0.2),
          bottom:
              BorderSide(color: Color.fromARGB(255, 139, 129, 129), width: 0.2),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 15),
              CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(post.profileImageUrl),
              ),
              const SizedBox(width: 10),
              Text(
                post.userName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(width: 120),
              Text(formatDateTime(post.timeStamp.toString()),
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 330,
            height: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFafcdfa),
                  Color(0xFF294266),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 35,
                  right: 120,
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage(post.profileImageUrl),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 55,
                  child: GestureDetector(
                    onTap: onTapPlayPause,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          )
                        : Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text(
                    'Innerspace',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Positioned(
                  bottom: 62,
                  right: 148,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/playbutton.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 15),
              UpvoteDownVote(), // Replace with your upvote/downvote widget
            ],
          ),
        ],
      ),
    );
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  String formatDuration(int duration) {
    // Format the duration to mm:ss
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '$minutes:$seconds';
  }
}
