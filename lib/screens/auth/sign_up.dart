import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';
import 'components/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Password',
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  onChanged: (val) {
                    setState(() {
                      passwordStrength = estimatePasswordStrength(val!);
                    });
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
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
              ),
              // Confirm Password Field
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
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
              ),
              // Password Strength Indicator
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: LinearProgressIndicator(
                  value: passwordStrength,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getPasswordStrengthColor(passwordStrength),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Use Visibility widget to conditionally show button or CircularProgressIndicator
              Visibility(
                visible: !signUpRequired,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        MyUser myUser = MyUser.empty;
                        myUser = myUser.copyWith(
                          email: emailController.text,
                        );
                        setState(() {
                          if (passwordStrength >= 0.3) {
                            // Only proceed with signup if password strength is good
                            context.read<SignUpBloc>().add(
                                  SignUpRequired(
                                    myUser,
                                    passwordController.text,
                                  ),
                                );
                            signUpRequired =
                                true; // Set signUpRequired to true here
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: signUpRequired,
                child: const CircularProgressIndicator(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
}
