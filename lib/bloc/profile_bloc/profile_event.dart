// profile_event.dart
part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class _UserProfileChanged extends ProfileEvent {
  final User user;

  const _UserProfileChanged(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateProfile extends ProfileEvent {
  final String newProfileData;

  const UpdateProfile(this.newProfileData);

  @override
  List<Object> get props => [newProfileData];
}
