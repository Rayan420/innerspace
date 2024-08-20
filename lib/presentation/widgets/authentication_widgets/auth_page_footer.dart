import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/values.dart';
import 'package:innerspace/constants/strings.dart';

class AuthPageFooter extends StatelessWidget {
  const AuthPageFooter({
    super.key,
    required this.isDarkMode,
    required this.tAuthMethod,
    required this.tAlternative,
    required this.route,
  });

  final bool isDarkMode;
  final String tAuthMethod;
  final String tAlternative;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                color: isDarkMode ? tWhiteColor : tBlackColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(tAuthMethod),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                color: isDarkMode ? tWhiteColor : tBlackColor,
              ),
            ),
          ],
        ),
        // const SizedBox(height: tFormHeight - 20),
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     side: const BorderSide(color: Colors.black12, width: 1),
        //     backgroundColor: isDarkMode ? tBlackColor : Colors.white,
        //     elevation: 5, // Increased elevation for a better shadow effect
        //     shadowColor: Colors.black26, // Shadow color for better contrast
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     padding: const EdgeInsets.symmetric(
        //         vertical: 12, horizontal: 24), // Adjusted padding
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const Image(
        //         image: AssetImage(tGoogleLogo),
        //         width: 24, // Adjusted width to make it look better
        //         height: 24, // Added height for better proportions
        //       ),
        //       const SizedBox(width: 12), // Space between image and text
        //       Text(
        //         'Continue with Google', // Added text for better context
        //         style: TextStyle(
        //           color: isDarkMode ? tWhiteColor : tBlackColor,
        //           fontSize: 16,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        TextButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, route);
          },
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextSpan(text: ' ${tAlternative.toUpperCase()}'),
          ])),
        )
      ],
    );
  }
}
