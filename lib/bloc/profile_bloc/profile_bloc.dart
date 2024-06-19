// profile_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  StreamSubscription<User>? _userSubscription;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<_UserProfileChanged>(_onUserProfileChanged);
    //on<UpdateProfile>(_onUpdateProfile);

    // Start listening to the user stream
    _userSubscription = userRepository.userStream.listen(
      (user) => add(_UserProfileChanged(user)),
    );
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.fetchUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(const ProfileError("Failed to load profile"));
    }
  }

  void _onUserProfileChanged(
      _UserProfileChanged event, Emitter<ProfileState> emit) {
    emit(ProfileLoaded(event.user));
  }

  // void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
  //   emit(ProfileLoading());
  //   try {
  //     final updatedUser = await userRepository.updateUserProfile(event.newProfileData);
  //     emit(ProfileLoaded(updatedUser));
  //   } catch (e) {
  //     emit(ProfileError("Failed to update profile"));
  //   }
  // }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
