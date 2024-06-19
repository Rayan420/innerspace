import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:user_repository/data.dart';
import 'package:user_repository/src/models/user.dart';

import '../../../constants/colors.dart';

class UserSearchCard extends StatelessWidget {
  const UserSearchCard({
    Key? key,
    required this.user,
    required this.userRepository,
  }) : super(key: key);

  final User user;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0), // Space around the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: user.userProfile.profilePicture != null &&
                        user.userProfile.profilePicture!.isNotEmpty
                    ? NetworkImage(user.userProfile.profilePicture!)
                    : AssetImage('assets/images/profile1.png') as ImageProvider,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Visibility(
                visible: user.userId != userRepository.user!.userId,
                child: SizedBox(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      // ignore: collection_methods_unrelated_type
                      userRepository.user!.following.contains(user.userId)
                          ? 'Unfollow'
                          : 'Follow',
                      style: const TextStyle(
                        color: tWhiteColor, // Set the text color to white
                        fontSize: 14, // Adjust the font size as needed
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (user.userProfile.bio != null &&
              user.userProfile.bio!.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              user.userProfile.bio!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            // add dateofbirth and date of joining
          ],
        ],
      ),
    );
  }
}
