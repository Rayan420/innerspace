part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpProcess extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileSignUpSuccess extends SignUpState {
  ProfileSignUpSuccess();

  @override
  List<Object> get props => [];
}

class ProfileSignUpProcess extends SignUpState {}

class ProfileSignUpFailure extends SignUpState {
  final String message;

  ProfileSignUpFailure({required this.message});

  @override
  List<Object> get props => [message];
}
