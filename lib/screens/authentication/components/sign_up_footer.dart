import 'package:flutter/material.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/sizes.dart';
import 'package:innerspace/constants/strings.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(tSignUpWith),
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
        const SizedBox(height: tFormHeight - 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.black12, width: 1),
            primary: tWhiteColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Image(
            image: AssetImage(tGoogleLogo),
            width: 20,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/login');
          },
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextSpan(text: tLogin.toUpperCase()),
          ])),
        ),
      ],
    );
  }
}
