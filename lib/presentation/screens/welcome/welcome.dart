// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/values.dart';
import 'package:innerspace/constants/strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var brightness = mediaQuery.platformBrightness;

    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tWhiteColor,
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tWelcomeTitle,
                    style: Theme.of(context).textTheme.headline3,
                    selectionColor: tWhiteColor,
                  ),
                  Text(
                    tWelcomeSubtitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12, width: 1), backgroundColor: tPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to SignIn screen

                      Navigator.pushNamed(context, '/onboarding');
                    },
                    child: Text(
                      tGetStarted.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
