import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:user_repository/data.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userRepository, required this.isdarkmode});

  final UserRepository userRepository;
  final bool isdarkmode;
  

  @override
  Widget build(BuildContext context) {
    
   



    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '@',
              style: TextStyle(fontSize: 24,fontFamily: 'Montserrat'),
            ),
            Text(
              userRepository.user!.username,
              style: TextStyle(fontSize: 24,fontFamily: 'Poppins'),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Iconsax.more,color: isdarkmode?Colors.white:Colors.black,))
        ],
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
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
                  backgroundImage: AssetImage('assets/images/zendaya.jpg'),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 108),
              Column(
                children: [
                  Text('Following',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Text('690',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Text('Followers',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  Text('690',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                ],
              ),
              SizedBox(width: 15,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                height: MediaQuery.of(context).size.height * 0.047,
                child: TextButton(
                  onPressed: () {
                    // Add your follow button logic here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: tPrimaryColor,foregroundColor: tWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // Text color
                  ),
                  child: Center(
                    child: Text(
                      'Follow',
                      style: TextStyle(fontSize: 16,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          
          
          Row(
            children: [
              SizedBox(width: 15,),
              Text('Social',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ],
          )
        ],
      ),
    );
  }
}
