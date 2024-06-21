import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/image_functions.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:innerspace/constants/theme/widgets/avatar.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({
    super.key,
  });

  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  Uint8List? selectedImageBytes;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when they are no longer needed
    descriptionController.dispose();
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            children: [
              GestureDetector(
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
                    SizedBox(height: heightSize * 0.07),
                    Avatar(
                      isDarkMode: isDarkmode,
                      selectedImageBytes: selectedImageBytes,
                      onImageSelected: (imageBytes) {
                        setState(() {
                          selectedImageBytes = imageBytes;
                        });
                      },
                    ),
                    SizedBox(height: heightSize * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: widthSize * 0.8,
                          child: Text(
                            tBio,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: descriptionController,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: null, // Allow unlimited lines
                            maxLength: 160, // Maximum length
                            textInputAction:
                                TextInputAction.done, // Prevent new lines
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 15, 10, 15),
                              hintMaxLines: 3,
                              hintText:
                                  'Please describe yourself but keep it under 160 characters.',
                            ),
                          ),
                        ),
                        SizedBox(height: heightSize * 0.03),
                        Text(
                          'Date of Birth:',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Year
                            SizedBox(
                              width: 90,
                              child: TextFormField(
                                controller: yearController,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'YYYY',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                ),
                              ),
                            ),
                            // Month
                            SizedBox(
                              width: 70,
                              child: TextFormField(
                                controller: monthController,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'MM',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                ),
                              ),
                            ),
                            // Day
                            SizedBox(
                              width: 70,
                              child: TextFormField(
                                controller: dayController,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'DD',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12),
                                  border: OutlineInputBorder(),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heightSize * 0.06),
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
                              final year = yearController.text;
                              final month = monthController.text;
                              final day = dayController.text;
                              final dob = '$year-$month-$day';

                              // Check if user is less than 16 years old
                              final dobDateTime = DateTime.tryParse(dob);
                              if (dobDateTime == null ||
                                  dobDateTime.isAfter(DateTime.now().subtract(
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
                                    dob,
                                  ),
                                );
                              }
                            },
                            child: const Text(tSetup),
                          ),
                        ),
                        SizedBox(height: heightSize * 0.01),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final year = yearController.text;
                              final month = monthController.text;
                              final day = dayController.text;
                              final dob = '$year-$month-$day';
                              // Check if user is less than 16 years old
                              final dobDateTime = DateTime.tryParse(dob);
                              if (dobDateTime == null ||
                                  dobDateTime.isAfter(DateTime.now().subtract(
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
                                    dob,
                                  ),
                                );
                              }
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
                        ),
                      ],
                    ),
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
