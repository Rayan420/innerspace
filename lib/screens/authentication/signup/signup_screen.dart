// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/common_widgets/form_header_widget.dart';
import 'package:innerspace/constants/sizes.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:innerspace/screens/authentication/components/my_text_field.dart';
import 'package:innerspace/screens/authentication/login/login_screen.dart';
import 'package:password_strength/password_strength.dart';
import 'package:user_repository/user_repository.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  double passwordStrength = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                children: [
                  const FormHeaderWidget(
                    image: tWelcomeScreenImage,
                    title: tsignUpTitle,
                    subtitle: tsignUpSubtitle,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            controller: nameController,
                            hintText: "Name",
                            prefixIcon: const Icon(CupertinoIcons.person),
                          ),
                          const SizedBox(height: tFormHeight - 20),
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
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Password',
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            onChanged: (val) {
                              setState(() {
                                passwordStrength =
                                    estimatePasswordStrength(val!);
                              });
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
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (passwordStrength < 0.3) {
                                return 'Weak password. Include uppercase, lowercase, and minimum 8 characters.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          MyTextField(
                            controller: confirmPasswordController,
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: 'Confirm Password',
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (val != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: LinearProgressIndicator(
                              value: passwordStrength,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getPasswordStrengthColor(passwordStrength),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !signUpRequired,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    MyUser myUser = MyUser.empty;
                                    myUser = myUser.copyWith(
                                      email: emailController.text,
                                    );
                                    setState(() {
                                      if (passwordStrength >= 0.3) {
                                        context.read<SignUpBloc>().add(
                                              SignUpRequired(
                                                myUser,
                                                passwordController.text,
                                              ),
                                            );
                                        signUpRequired = true;
                                      }
                                    });
                                  }
                                },
                                child: Text(tSignUp.toUpperCase()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text("OR"),
                      const SizedBox(
                        height: tFormHeight - 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Navigate back to welcome screen
                            Navigator.pop(context);
                          },
                          icon: const Image(
                              image: AssetImage(tGoogleLogo), width: 20),
                          label: const Text(tSignUpWithGoogle),
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
                  ),
                  Visibility(
                    visible: signUpRequired,
                    child: const CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _getPasswordStrengthColor(double strength) {
  if (strength > 0.7) {
    return Colors.green;
  } else if (strength > 0.4) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
