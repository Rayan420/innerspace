import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/bloc/profile_bloc/profile_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:user_repository/data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.userRepository, required this.isdarkmode});

  final UserRepository userRepository;
  final bool isdarkmode;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                '@',
                style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
              ),
              Text(
                widget.userRepository.user!.username,
                style: const TextStyle(fontSize: 24, fontFamily: 'Poppins'),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Iconsax.more,
                  color: widget.isdarkmode ? Colors.white : Colors.black,
                ))
          ],
        ),
        body: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cover_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: 10.0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.userRepository.user!.userProfile
                                    .profilePicture !=
                                null &&
                            widget.userRepository.user!.userProfile
                                .profilePicture!.isNotEmpty
                        ? NetworkImage(widget
                            .userRepository.user!.userProfile.profilePicture!)
                        : const AssetImage(
                            'assets/images/profile1.png',
                          ) as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 108),
                Column(
                  children: [
                    const Text(
                      'Following',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                        widget.userRepository.user!.userProfile.followingCount
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    const Text('Followers',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                        widget.userRepository.user!.userProfile.followerCount
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15))
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: MediaQuery.of(context).size.height * 0.047,
                  child: TextButton(
                    onPressed: () {
                      // Add your edit button logic here
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      foregroundColor: tWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ), // Text color
                    ),
                    child: const Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "${widget.userRepository.user!.firstName} ${widget.userRepository.user!.lastName}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.userRepository.user!.userProfile.bio ?? "",
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            // add date joined and date of birth
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 6,
                ),
                const Icon(
                  Iconsax.calendar5,
                  color: Colors.grey,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Joined ${widget.userRepository.user!.dateJoined}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            Row(
              children: [
                const SizedBox(
                  width: 6,
                ),
                const Icon(
                  Iconsax.calendar5,
                  color: Colors.grey,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Born on ${widget.userRepository.user!.dateOfBirth}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            TabBar(
              controller: _tabController,
              labelColor: tPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: tPrimaryColor,
              tabs: const [
                Tab(text: 'Tweets'),
                Tab(text: 'Replies'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('Tweets content goes here')),
                  const Center(child: Text('Replies content goes here')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
