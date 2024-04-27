import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final UserRepository _userRepository;

  PasswordResetBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(PasswordResetInitial()) {
    on<PasswordResetRequired>((event, emit) async {
      emit(PasswordResetProcess());
      try {
        //_userRepository.resetPassword(event.email);
        print("Password reset email sent");
        emit(PasswordResetSuccess());
      } on FirebaseException catch (e) {
        print(e);
        emit(PasswordResetFailure(message: e.code));
      } catch (e) {
        print(e);
        emit(PasswordResetFailure(message: e.toString()));
      }
    });
  }
}
