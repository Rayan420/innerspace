// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:innerspace/constants/theme/widgets/primary_textformfield.dart';
import 'package:innerspace/data/models/auth_models/sign_up_model.dart';

import 'package:innerspace/presentation/widgets/authentication_widgets/my_text_field.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/auth_page_footer.dart';
import 'package:innerspace/presentation/widgets/common_widgets/form_header_widget.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/values.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:password_strength/password_strength.dart';
import 'package:quickalert/quickalert.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;
  double passwordStrength = 0.0;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var brightness = mediaQuery.platformBrightness;

    final isDarkMode = brightness == Brightness.dark;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
            Navigator.popAndPushNamed(context, '/profile-setup');
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          _error = state.message;
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: _error,
          );
          setState(() {
            signUpRequired = false; // Reset signUpRequired
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
                  Navigator.popAndPushNamed(context, "/login");
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
                        title: tsignUpTitle,
                        subtitle: tsignUpSubtitle,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: tFormHeight - 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PrimaryTextFormField(
                                        borderRadius: BorderRadius.circular(40),
                                        hintText: 'Khalid',
                                        controller: firstNameController,
                                        isDarkMode: isDarkMode,
                                        width: 155,
                                        height: 58,
                                        validator: 'Please enter a first name',
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: tFormHeight - 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      PrimaryTextFormField(
                                        borderRadius: BorderRadius.circular(40),
                                        hintText: 'Mohammed',
                                        controller: lastNameController,
                                        isDarkMode: isDarkMode,
                                        width: 155,
                                        height: 58,
                                        validator: 'Please enter a last name',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: tFormHeight - 20),
                                ],
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              MyTextField(
                                controller: userNameController,
                                hintText: "Username",
                                prefixIcon:
                                    const Icon(CupertinoIcons.person_fill),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter a username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon:
                                    const Icon(CupertinoIcons.mail_solid),
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
                                prefixIcon:
                                    const Icon(CupertinoIcons.lock_fill),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: LinearProgressIndicator(
                                  value: passwordStrength,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getPasswordStrengthColor(passwordStrength),
                                  ),
                                ),
                              ),
                              const SizedBox(height: tFormHeight - 20),
                              Visibility(
                                visible: !signUpRequired,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.grey, width: 0.5),
                                          backgroundColor: tPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (BlocProvider.of<InternetBloc>(
                                                    context)
                                                .isConnected()) {
                                              SignUpModel myUser = SignUpModel(
                                                  username:
                                                      userNameController.text,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  firstName:
                                                      firstNameController.text,
                                                  lastName:
                                                      lastNameController.text);
                                              setState(() {
                                                if (passwordStrength >= 0.3) {
                                                  context
                                                      .read<SignUpBloc>()
                                                      .add(SignUpRequired(
                                                          myUser));
                                                  signUpRequired = true;
                                                }
                                              });
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
                                                  duration: const Duration(
                                                      seconds: 3),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text(tSignUp.toUpperCase()),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    AuthPageFooter(
                                      isDarkMode: isDarkMode,
                                      tAuthMethod: tSignUpWith,
                                      tAlternative: tLogin,
                                      route: '/login',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: signUpRequired,
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

Color _getPasswordStrengthColor(double strength) {
  if (strength > 0.7) {
    return Colors.green;
  } else if (strength > 0.4) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
