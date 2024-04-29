part of 'password_reset_bloc.dart';

sealed class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class PasswordResetRequired extends PasswordResetEvent {
  final String email;

  const PasswordResetRequired({required this.email});
}

class VerifyOtpRequired extends PasswordResetEvent {
  final String otp;

  const VerifyOtpRequired({required this.otp});
}

class ConfirmPasswordReset extends PasswordResetEvent {
  final String password;

  const ConfirmPasswordReset({required this.password});
}
