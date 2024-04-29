
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innerspace/bloc/internet_bloc/internet_bloc.dart';
import 'package:innerspace/bloc/password_reset_bloc/password_reset_bloc.dart';
import 'package:innerspace/constants/theme/widgets/otp_row_widget.dart';
import 'package:innerspace/presentation/widgets/authentication_widgets/my_text_field.dart';
import 'package:innerspace/presentation/widgets/common_widgets/form_header_widget.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:innerspace/constants/sizes.dart';
import 'package:innerspace/constants/strings.dart';
import 'package:password_strength/password_strength.dart';
import 'package:quickalert/quickalert.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _resetFormKey = GlobalKey<FormState>(); // Unique key for reset form
  final _otpFormKey = GlobalKey<FormState>(); // Unique key for OTP form
  final _newPasswordFormKey =
      GlobalKey<FormState>(); // Unique key for new password form
  String? _errorMsg;
  bool resetRequired = false;
  bool otpRequired = false;
  bool confirmRequired = false;
  bool resetPage = true;
  bool otpPage = false;
  bool confirmPage = false;
  List<String> otpValues = List.filled(6, '');
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  double passwordStrength = 0.0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            resetPage = false;
            otpPage = true;
          });
        } else if (state is PasswordResetProcess) {
          setState(() {
            resetRequired = true;
          });
        } else if (state is PasswordResetFailure) {
          setState(() {
            resetRequired = false;
            _errorMsg = 'Invalid email';
            resetPage = true;
          });
        } else if (state is VerifyOtpSuccess) {
          setState(() {
            otpRequired = false;
            otpPage = false;
            confirmPage = true;
          });
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'OTP verified, you can now reset your password',
          );
        } else if (state is VerifyOtpFailure) {
          setState(() {
            otpRequired = false;
          });
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Invalid OTP',
          );
        } else if (state is VerifyOtpProcess) {
          setState(() {
            otpRequired = true;
          });
        } else if (state is ConfirmPasswordResetSuccess) {
          setState(() {
            confirmRequired = false;
            confirmPage = false;
            resetPage = true;
            Navigator.pop(context);
          });
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Your password was reset, you can login now',
          );
        } else if (state is ConfirmPasswordResetFailure) {
          setState(() {
            confirmRequired = false;
          });
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: state.message,
          );
        } else if (state is ConfirmPasswordResetProcess) {
          setState(() {
            confirmRequired = true;
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
                      if (resetPage)
                        const FormHeaderWidget(
                          title: tForgotPasswordTitle,
                          subtitle: tForgotPasswordSubtitle,
                        ),
                      if (otpPage)
                        const FormHeaderWidget(
                          title: tVerifyOtpTitle,
                          subtitle: tVerifyOtpSubtitle,
                        ),
                      if (confirmPage)
                        const FormHeaderWidget(
                          title: tNewPasswordTitle,
                          subtitle: tNewPasswordSubtitle,
                        ),
                      const SizedBox(height: 20),
                      if (resetPage)
                        ResetPage(
                          formKey: _resetFormKey,
                          emailController: emailController,
                          errorMsg: _errorMsg,
                          resetRequired: resetRequired,
                          isDarkMode: isDarkMode,
                          otpValues: otpValues,
                          widget: MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(CupertinoIcons.mail_solid),
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
                          onValueChanged: () {
                            if (_resetFormKey.currentState!.validate()) {
                              if (BlocProvider.of<InternetBloc>(context)
                                  .isConnected()) {
                                context.read<PasswordResetBloc>().add(
                                    PasswordResetRequired(
                                        email: emailController.text.trim()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          text: tSendLink,
                        ),
                      if (otpPage)
                        ResetPage(
                          formKey: _otpFormKey,
                          emailController: emailController,
                          errorMsg: _errorMsg,
                          resetRequired: resetRequired,
                          isDarkMode: isDarkMode,
                          otpValues: otpValues,
                          widget: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (int i = 0; i < 6; i++)
                                  textFieldOTP(index: i),
                              ],
                            ),
                          ),
                          text: tVerify,
                          onValueChanged: () {
                            bool isOTPComplete =
                                otpValues.every((value) => value.isNotEmpty);
                            if (isOTPComplete) {
                              if (BlocProvider.of<InternetBloc>(context)
                                  .isConnected()) {
                                String concatenatedOTP = otpValues
                                    .join()
                                    .replaceAll(RegExp(r'\D'), '');

                                context.read<PasswordResetBloc>().add(
                                    VerifyOtpRequired(otp: concatenatedOTP));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      if (confirmPage)
                        ResetPage(
                          formKey: _newPasswordFormKey,
                          emailController: emailController,
                          errorMsg: _errorMsg,
                          resetRequired: resetRequired,
                          isDarkMode: isDarkMode,
                          otpValues: otpValues,
                          widget: MyTextField(
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
                          onValueChanged: () {
                            if (_newPasswordFormKey.currentState!.validate()) {
                              if (BlocProvider.of<InternetBloc>(context)
                                  .isConnected()) {
                                context.read<PasswordResetBloc>().add(
                                    ConfirmPasswordReset(
                                        password: passwordController.text));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          },
                          text: tNewPassword,
                        ),
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
                      Visibility(
                        visible: resetRequired || otpRequired,
                        child: const CircularProgressIndicator(
                          color: tPrimaryColor,
                          backgroundColor: tSecondaryColor,
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

  Widget textFieldOTP({required int index}) {
    return Expanded(
      child: Container(
        height: 85,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: TextField(
            onChanged: (value) {
              if (value.isNotEmpty && index <= otpValues.length - 1) {
                setState(() {
                  otpValues[index] = value;
                });
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                setState(() {
                  otpValues[index] = value;
                });
                FocusScope.of(context).previousFocus();
              }
            },
            showCursor: false,
            readOnly: false,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counter: const Offstage(),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12),
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
