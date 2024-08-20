import 'package:flutter/material.dart';
import 'package:user_repository/data.dart';

class UpvoteDownVote extends StatefulWidget {
  const UpvoteDownVote({
    Key? key,
    required this.timelineRepository,
    required this.postId,
  }) : super(key: key);
  final TimelineRepository timelineRepository;
  final int postId;
  @override
  _UpvoteDownVoteState createState() => _UpvoteDownVoteState();
}

class _UpvoteDownVoteState extends State<UpvoteDownVote> {
  int count = 0;
  bool isUpvoted = false;
  bool isDownvoted = false;

  void toggleUpvote() async {
    if (!isUpvoted) {
      setState(() {
        count++;
        isUpvoted = true;
        isDownvoted = false; // Reset downvote
      });
      await widget.timelineRepository.vote('upvote',
          widget.postId); // Replace postId and senderId with actual values
    } else {
      setState(() {
        count--;
        isUpvoted = false;
      });
    }
  }

  void toggleDownvote() async {
    if (!isDownvoted) {
      setState(() {
        count--;
        isDownvoted = true;
        isUpvoted = false; // Reset upvote
      });
      await widget.timelineRepository.vote('downvote',
          widget.postId); // Replace postId and senderId with actual values
    } else {
      setState(() {
        count++;
        isDownvoted = false;
      });
    }
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
