import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';

class ProfileScreenOther extends StatefulWidget {
  const ProfileScreenOther({super.key, required this.isdarkmode});

  final bool isdarkmode;

  @override
  _ProfileScreenOtherState createState() => _ProfileScreenOtherState();
}

class _ProfileScreenOtherState extends State<ProfileScreenOther>
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              '@',
              style: TextStyle(fontSize: 24, fontFamily: 'Montserrat'),
            ),
            Text(
              "user",
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
                left: 20.0,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      const AssetImage('assets/images/profile1.png')
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
                  Text('count',
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
                  Text('count',
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
                  onPressed: () {
                    // Add your follow button logic here
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
                      'Follow',
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
                "user name",
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  "bio here",
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.clip,
                ),
              ),
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
