part of 'password_reset_bloc.dart';

sealed class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object> get props => [];
}

final class PasswordResetInitial extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {}

class PasswordResetFailure extends PasswordResetState {
  final String? message;

  const PasswordResetFailure({this.message});
}

class PasswordResetProcess extends PasswordResetState {}

class VerifyOtpSuccess extends PasswordResetState {}

class VerifyOtpProcess extends PasswordResetState {}

class VerifyOtpFailure extends PasswordResetState {
  final String? message;

  const VerifyOtpFailure({this.message});
}

class ConfirmPasswordResetSuccess extends PasswordResetState {}

class ConfirmPasswordResetProcess extends PasswordResetState {}

class ConfirmPasswordResetFailure extends PasswordResetState {
  final String? message;

  const ConfirmPasswordResetFailure({this.message});
}
