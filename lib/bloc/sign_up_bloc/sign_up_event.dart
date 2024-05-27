part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final SignUpModel user;

  const SignUpRequired(this.user);
}

class CompleteSignUp extends SignUpEvent {
  final Uint8List? image;
  final String bio;
  final String dob;

  const CompleteSignUp(this.image, this.bio, this.dob);
}
