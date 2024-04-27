import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innerspace/data/models/sign_up_model.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        await _userRepository.signUp(
            username: event.user.username,
            email: event.user.email,
            password: event.user.password);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(
            message: e.toString().contains("email-already-in-use")
                ? "Email already in use"
                : e.toString()));
      }
    });
  }
}
