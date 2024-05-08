import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/image_functions.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:innerspace/constants/theme/widgets/avatar.dart';
import 'package:innerspace/constants/theme/widgets/avatar_list.dart';
import 'package:intl/intl.dart';

class ProfileSetup extends StatefulWidget {
  ProfileSetup({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  Uint8List? selectedImageBytes;
  TextEditingController descriptionController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void dispose() {
    // Dispose of the controller when it's no longer needed
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var heightSize = mediaQuery.size.height;
    var widthSize = mediaQuery.size.width;

    var brightness = mediaQuery.platformBrightness;

    final isDarkmode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is ProfileSignUpSuccess) {
              Navigator.popAndPushNamed(context, '/');
            } else if (state is SignUpFailure) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: Text('Failed to update profile: ${state.message}'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tSetProfileTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        tSetProfileSubtitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: heightSize * 0.07,
                      ),
                      Avatar(
                        selectedImageBytes: selectedImageBytes,
                        onImageSelected: (imageBytes) {
                          setState(() {
                            selectedImageBytes = imageBytes;
                          });
                        },
                      ),
                      SizedBox(
                        height: heightSize * 0.01,
                      ),
                      AvatarList(onAvatarSelected: (imageBytes) {
                        setState(() {
                          selectedImageBytes = imageBytes;
                        });
                      }),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: widthSize * 0.8,
                            child: Text(
                              tBio,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: null, // Remove fixed height
                              width: widthSize * 0.9,
                              child: Stack(
                                children: [
                                  TextFormField(
                                    controller: descriptionController,
                                    textAlignVertical: TextAlignVertical.top,
                                    onChanged: (_) {
                                      setState(
                                          () {}); // Update the character count
                                    },
                                    maxLines: null, // Allow unlimited lines
                                    maxLength: 160, // Maximum length
                                    textInputAction: TextInputAction
                                        .done, // Prevent new lines

                                    decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 15, 10, 15),
                                      hintMaxLines: 3,
                                      hintText:
                                          'Please describe yourself but keep it under 160 characters.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CupertinoDateTextBox(
                            initialValue: _selectedDateTime,
                            onDateChange: onDateChange,
                            hintText:
                                DateFormat.yMd().format(_selectedDateTime),
                            color: isDarkmode
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                          ),
                          SizedBox(
                            height: heightSize * 0.06,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.grey, width: 0.5),
                                backgroundColor: tPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () async {
                                // check if user is less than 16 years old
                                if (_selectedDateTime.isAfter(DateTime.now()
                                    .subtract(
                                        const Duration(days: 16 * 365)))) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: const Text(
                                            'You must be at least 16 years old to use this app.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                } else {
                                  selectedImageBytes ??=
                                      await getImageBytes('profile', 1);

                                  BlocProvider.of<SignUpBloc>(context).add(
                                      CompleteSignUp(
                                          selectedImageBytes!,
                                          descriptionController.text,
                                          _selectedDateTime));
                                }
                              },
                              child: const Text(tSetup),
                            ),
                          ),
                          SizedBox(
                            height: heightSize * 0.01,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.popAndPushNamed(context, '/home');
                            },
                            child: Text(
                              "Skip for now",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: isDarkmode
                                        ? tWhiteColor
                                        : tSecondaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDateChange(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
    });
  }
}
