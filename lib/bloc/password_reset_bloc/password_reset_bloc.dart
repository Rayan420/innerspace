import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innerspace/data/models/auth_models/reset_password_model.dart';
import 'package:user_repository/data.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  final AuthenticationRepository _authRepository;
  final ResetPasswordModel model = ResetPasswordModel();

  PasswordResetBloc({required AuthenticationRepository authRepository})
      : _authRepository = authRepository,
        super(PasswordResetInitial()) {
    on<PasswordResetRequired>((event, emit) async {
      emit(PasswordResetProcess());
      try {
        await _authRepository.resetPassword(event.email);
        model.email = event.email;
        emit(PasswordResetSuccess());
      } catch (e) {
        emit(PasswordResetFailure(message: e.toString()));
      }
    });

    on<VerifyOtpRequired>((event, emit) async {
      emit(VerifyOtpProcess());
      try {
        var response =
            await _authRepository.confirmOtp(model.email!, event.otp);
        // Map the response to your ResetPasswordModel
        var x = ResetPasswordModel.fromJson(response);
        model.token = x.token;
        model.message = x.message;
        // Emit success state
        emit(VerifyOtpSuccess());
      } catch (e) {
        emit(VerifyOtpFailure(message: e.toString()));
      }
    });

    on<ConfirmPasswordReset>((event, emit) async {
      emit(ConfirmPasswordResetProcess());
      try {
        //print the password
        await _authRepository.confirmPasswordReset(
            model.email!, model.token!, event.password);
        emit(ConfirmPasswordResetSuccess());
      } catch (e) {
        emit(const ConfirmPasswordResetFailure(
            message: 'Failed to reset password'));
      }
    });
  }
}
