import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/bloc/authentiction_bloc/authentication_bloc.dart';
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
    // Load the profile when the screen initializes
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Actions'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              // Add your settings button logic here
              Navigator.pop(context);
            },
            child: const Text('Settings'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // Trigger the logout event
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.pop(context);
            },
            child: const Text('Logout'),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          widget.userRepository.user = state.user;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('@',
                  style: TextStyle(fontSize: 24, fontFamily: 'Montserrat')),
              Text(widget.userRepository.user?.username ?? '',
                  style: const TextStyle(fontSize: 24, fontFamily: 'Poppins')),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showActionSheet(context);
              },
              icon: Icon(
                Iconsax.more,
                color: widget.isdarkmode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
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
                          backgroundImage: user.userProfile.profilePicture !=
                                      null &&
                                  user.userProfile.profilePicture!.isNotEmpty
                              ? NetworkImage(user.userProfile.profilePicture!)
                              : const AssetImage('assets/images/profile1.png')
                                  as ImageProvider,
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
                          const Text('Following',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(user.userProfile.followingCount.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          const Text('Followers',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(user.userProfile.followerCount.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(width: 15),
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
                            ),
                          ),
                          child: const Center(
                            child: Text('Edit', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Text("${user.firstName} ${user.lastName}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          user.userProfile.bio ?? "",
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 6),
                      const Icon(Iconsax.calendar5,
                          color: Colors.grey, size: 15),
                      const SizedBox(width: 5),
                      Text('Joined ${user.dateJoined}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 6),
                      const Icon(Iconsax.calendar5,
                          color: Colors.grey, size: 15),
                      const SizedBox(width: 5),
                      Text('Born on ${user.dateOfBirth}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
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
                      children: const [
                        Center(child: Text('Tweets content goes here')),
                        Center(child: Text('Replies content goes here')),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
