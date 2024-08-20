import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/profile_bloc/profile_bloc.dart';
import 'package:innerspace/constants/helper.dart';
import 'dart:typed_data';
import 'package:innerspace/constants/theme/widgets/cover_image.dart';
import 'package:innerspace/presentation/screens/profile/profile_screen.dart';
import 'package:user_repository/data.dart'; // Assuming you have the necessary imports
import 'package:innerspace/constants/theme/widgets/avatar.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {Key? key, required this.userRepository, required this.isDarMode})
      : super(key: key);
  final UserRepository userRepository;
  final bool isDarMode;
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Uint8List? selectedProfileImageBytes;
  Uint8List? selectedCoverImageBytes;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = widget.userRepository.user!;
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    bioController.text = user.userProfile.bio!;
  }

  Future<void> updateProfile() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String bio = bioController.text;
    Uint8List? profilePicture = selectedProfileImageBytes;
    Uint8List? coverPicture = selectedCoverImageBytes;

    BlocProvider.of<ProfileBloc>(context).add(UpdateProfile(
      firstName: firstName,
      lastName: lastName,
      bio: bio,
      profilePicture: profilePicture,
      coverPicture: coverPicture,
    ));

    Navigator.pop(context);
  }
  // detect if the page was popped and emit the cancel event

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
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 84, 126),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CoverPicture(
                        isDarkMode: widget.isDarMode,
                        selectedImageBytes: selectedCoverImageBytes,
                        onImageSelected: (imageBytes) {
                          setState(() {
                            selectedCoverImageBytes = imageBytes;
                          });
                        },
                        imageUrl: BackendUrls.replaceToIp(widget
                            .userRepository.user!.userProfile.coverPicture!),
                      ),
                    ),
                    Positioned(
                        top: 115, // Adjust top position as needed
                        left: 20, // Adjust left position as needed
                        child: Avatar(
                          isDarkMode: widget.isDarMode,
                          selectedImageBytes: selectedProfileImageBytes,
                          onImageSelected: (imageBytes) {
                            setState(() {
                              selectedProfileImageBytes = imageBytes;
                            });
                          },
                          imageUrl: BackendUrls.replaceFromLocalhost(
                            widget.userRepository.user!.userProfile
                                .profilePicture!,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'First Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                    ),
                    TextField(
                      controller: firstNameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Last Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                    ),
                    TextField(
                      controller: lastNameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bio',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                    ),
                    TextField(
                      controller: bioController,
                      maxLines: null,
                      maxLength: 160,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Text('Save Changes'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
