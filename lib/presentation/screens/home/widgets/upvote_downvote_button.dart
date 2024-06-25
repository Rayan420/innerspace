import 'package:flutter/material.dart';

class UpvoteDownVote extends StatefulWidget {
  const UpvoteDownVote({super.key});

  @override
  State<UpvoteDownVote> createState() => _UpvoteDownVoteState();
}

class _UpvoteDownVoteState extends State<UpvoteDownVote> {
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
            isUpvoted
                ? 'assets/images/upvoteClicked.png'
                : 'assets/images/upvote.png',
            width: 30,
            height: 30,
          ),
        ),
        const SizedBox(width: 5),
        Text('$count'),
        const SizedBox(width: 10),
        Container(
          width: 0.5,
          height: 15,
          color: const Color.fromARGB(255, 139, 129, 129),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: toggleDownvote,
          child: Image.asset(
            isDownvoted
                ? 'assets/images/downvoteClicked.png'
                : 'assets/images/downvote.png',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}
