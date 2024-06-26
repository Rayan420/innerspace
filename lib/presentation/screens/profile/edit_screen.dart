// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:user_repository/data.dart'; // Assuming you have the necessary imports
import 'package:innerspace/constants/theme/widgets/avatar.dart'; // Import the Avatar widget

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required this.userRepository}) : super(key: key);
  final UserRepository userRepository;
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Uint8List? selectedImageBytes; // Add this variable to hold the selected image bytes


  TextEditingController firstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user data
    firstNameController.text = widget.userRepository.user!.firstName!;
    LastNameController.text = widget.userRepository.user!.lastName!;
    bioController.text = widget.userRepository.user!.userProfile.bio!;
  }










  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 33, 84, 126)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 65,
                      right: 170,
                      child: Image.asset(
                        'assets/images/camera.png',
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: 20,
                      child: Container(
                        width: 100, // Set the desired width
                        height: 100, // Set the desired height
                        child: Avatar(
                          isDarkMode: true,
                          selectedImageBytes: selectedImageBytes,
                          onImageSelected: (imageBytes) {
                            setState(() {
                              selectedImageBytes = imageBytes;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('First Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w100),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                child: TextField(
                  controller: firstNameController,
                  style: TextStyle(fontSize: 18), // Set the desired font size
                  decoration: InputDecoration(
                     // Add placeholder text
                    contentPadding: EdgeInsets.symmetric(vertical: 1), // Set the desired content padding
                    enabledBorder: UnderlineInputBorder( // Use UnderlineInputBorder for bottom line when not focused
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0
                      )
                    ),
                    focusedBorder: UnderlineInputBorder( // Use UnderlineInputBorder for bottom line when focused
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Last Name',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w100),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                child: TextField(
                  controller: LastNameController,
                  style: TextStyle(fontSize: 18), // Set the desired font size
                  decoration: InputDecoration(
                     // Add placeholder text
                    contentPadding: EdgeInsets.symmetric(vertical: 1), // Set the desired content padding
                    enabledBorder: UnderlineInputBorder( // Use UnderlineInputBorder for bottom line when not focused
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0
                      )
                    ),
                    focusedBorder: UnderlineInputBorder( // Use UnderlineInputBorder for bottom line when focused
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('Bio',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w100),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: bioController,
                  maxLines: null, 
                  maxLength: 160,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    // Provide a hint text
                    contentPadding: EdgeInsets.symmetric(vertical: 20), // Adjust content padding
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
