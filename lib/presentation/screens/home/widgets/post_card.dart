import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:innerspace/constants/helper.dart';
import 'package:innerspace/presentation/screens/home/widgets/upvote_downvote_button.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/data.dart'; // Replace with your actual data model
import 'package:avatar_glow/avatar_glow.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTapPlayPause;
  final bool isPlaying;
  final bool isLoading;
  final TimelineRepository timelineRepository;

  const PostCard({
    required this.post,
    required this.onTapPlayPause,
    required this.isPlaying,
    required this.isLoading,
    Key? key,
    required this.timelineRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1c1c1c),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(
                    BackendUrls.replaceFromLocalhost(post.profileImageUrl)),
              ),
              const SizedBox(width: 10),
              Text(
                post.userName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              const Spacer(),
              Text(
                formatDateTime(post.timeStamp.toString()),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
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
              alignment: Alignment.center,
              children: [
                AvatarGlow(
                  glowColor: Colors.blueAccent,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  animate: isPlaying,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        BackendUrls.replaceFromLocalhost(post.profileImageUrl)),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                if (isLoading)
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  )
                else
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: onTapPlayPause,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 15),
              UpvoteDownVote(
                timelineRepository: timelineRepository,
                postId: post.id,
              ), // Replace with your upvote/downvote widget
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
