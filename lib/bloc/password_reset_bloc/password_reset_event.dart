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
