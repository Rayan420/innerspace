import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innerspace/data/models/auth_models/sign_up_model.dart';
import 'package:user_repository/data.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository _authRepository;



  SignUpBloc({required AuthenticationRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        await _authRepository.signUp(
            username: event.user.username,
            email: event.user.email,
            password: event.user.password,
            firstName: event.user.firstName,
            lastName: event.user.lastName);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(
            message: e.toString().contains("email-already-in-use")
                ? "Email already in use"
                : e.toString()));
      }
    });

    on<CompleteSignUp>((event, emit) async {
      emit(ProfileSignUpProcess());
      try {


        await _authRepository.signUpComplete(
            bio: event.bio, avatar: event.image!, dob: event.dob);
        emit(const ProfileSignUpSuccess());
      } catch (e) {
        emit(ProfileSignUpFailure(message: e.toString()));
      }
    });
  }
}
