import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:user_repository/src/models/user.dart';

class ProfileScreenOther extends StatefulWidget {
  const ProfileScreenOther({
    Key? key,
    required this.isdarkmode,
    required this.user,
    required this.isFollowing,
    required this.onFollowChanged,
    required this.toggleFollowStatus,
  }) : super(key: key);

  final bool isdarkmode;
  final User user;
  final bool isFollowing;
  final ValueChanged<bool> onFollowChanged;
  final Future<void> Function() toggleFollowStatus;

  @override
  _ProfileScreenOtherState createState() => _ProfileScreenOtherState();
}

class _ProfileScreenOtherState extends State<ProfileScreenOther>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _isFollowing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _isFollowing = widget.isFollowing;
  }

  Future<void> _toggleFollowStatus() async {
    setState(() {
      _isLoading = true;
    });

    await widget.toggleFollowStatus();

    setState(() {
      _isLoading = false;
      _isFollowing = !_isFollowing;
    });

    widget.onFollowChanged(_isFollowing);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              '@',
              style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
            ),
            Text(
              widget.user.username,
              style: const TextStyle(fontSize: 24, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
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
                  backgroundImage: widget.user.userProfile.profilePicture !=
                              null &&
                          widget.user.userProfile.profilePicture!.isNotEmpty
                      ? NetworkImage(widget.user.userProfile.profilePicture!)
                      : const AssetImage('assets/images/profile1.png')
                          as ImageProvider,
                  backgroundColor: Colors.white,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(widget.user.userProfile.followingCount.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Text('Followers',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(widget.user.userProfile.followerCount.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.047,
                child: TextButton(
                  onPressed: _toggleFollowStatus,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        _isFollowing ? Colors.grey.shade500 : tPrimaryColor,
                    foregroundColor: tWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // Text color
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: tWhiteColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isFollowing ? 'Unfollow' : 'Follow',
                          style: TextStyle(
                            color: _isFollowing && !widget.isdarkmode
                                ? Colors.black
                                : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
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
                "${widget.user.firstName} ${widget.user.lastName}",
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
                  widget.user.userProfile.bio ?? '',
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
              const Icon(Iconsax.calendar5, color: Colors.grey, size: 15),
              const SizedBox(width: 5),
              Text('Joined ${widget.user.dateJoined}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 6),
              const Icon(Iconsax.calendar5, color: Colors.grey, size: 15),
              const SizedBox(width: 5),
              Text('Born on ${widget.user.dateOfBirth}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(
            height: 20,
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
    );
  }
}
