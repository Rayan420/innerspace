// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/my_text_field.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/auth_page_footer.dart';
import 'package:innerspace/presentation/widgets/common_widgets/form_header_widget.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/sizes.dart';
import 'package:innerspace/constants/strings.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var brightness = mediaQuery.platformBrightness;

    final isDarkMode = brightness == Brightness.dark;
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
            Navigator.pop(context);
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          // Close the keyboard when tapped outside of a text field
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(tDefaultSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const FormHeaderWidget(
                        title: tLoginTitle,
                        subtitle: tLoginSubtitle,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: tFormHeight - 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(CupertinoIcons.mail),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                prefixIcon:
                                    const Icon(CupertinoIcons.lock_fill),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      if (obscurePassword) {
                                        iconPassword = CupertinoIcons.eye_fill;
                                      } else {
                                        iconPassword =
                                            CupertinoIcons.eye_slash_fill;
                                      }
                                    });
                                  },
                                  icon: Icon(iconPassword),
                                ),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/forgot-password');
                                    },
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: tForgotPasswordTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ]))),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              Visibility(
                                visible: !signInRequired,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.grey, width: 0.5),
                                          primary: tPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (BlocProvider.of<InternetBloc>(
                                                    context)
                                                .isConnected()) {
                                              context.read<SignInBloc>().add(
                                                  SignInRequired(
                                                      emailController.text,
                                                      passwordController.text));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: isDarkMode
                                                      ? Colors.black
                                                      : Colors.white,
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.warning,
                                                        color: isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              8), // Adjust the spacing as needed
                                                      Text(
                                                        'No internet connection',
                                                        style: TextStyle(
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text(tLogin.toUpperCase()),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    AuthPageFooter(
                                      isDarkMode: isDarkMode,
                                      tAuthMethod: tSignInWith,
                                      tAlternative: tSignUp,
                                      route: '/signup',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: signInRequired,
                        child: const CircularProgressIndicator(
                          color: tPrimaryColor,
                          backgroundColor: tSecondaryColor,
                          semanticsLabel: "Signing In...",
                          strokeWidth: 5,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
