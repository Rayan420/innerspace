import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/password_reset_bloc/password_reset_bloc.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/my_text_field.dart';
import 'package:innerspace/presentation/widgets/common_widgets/form_header_widget.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/sizes.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:quickalert/quickalert.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;
  bool resetRequired = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;

    final isDarkMode = brightness == Brightness.dark;
    return BlocListener<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          setState(() {
            resetRequired = false;
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Password reset link has been sent to your email',
            );
          });
        } else if (state is PasswordResetProcess) {
          setState(() {
            resetRequired = true;
          });
        } else if (state is PasswordResetFailure) {
          setState(() {
            resetRequired = false;
            _errorMsg = 'Invalid email';
            print("state message //${state.message}");
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHeaderWidget(
                        title: tForgotPasswordTitle.toUpperCase(),
                        subtitle: tForgotPasswordSubtitle,
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
                                errorMsg: _errorMsg,
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
                              Visibility(
                                  visible: !resetRequired,
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
                                                context
                                                    .read<PasswordResetBloc>()
                                                    .add(PasswordResetRequired(
                                                        email: emailController
                                                            .text
                                                            .trim()));
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
                                          child: Text(tSendLink.toUpperCase()),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: resetRequired,
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
