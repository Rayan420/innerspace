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
  final String firstName;
  final String lastName;
  final String bio;
  final Uint8List? profilePicture;
  final Uint8List? coverPicture;

  UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.bio,
    this.profilePicture,
    this.coverPicture,
  });


  @override
  List<Object> get props => [firstName, lastName, bio,];
}
class NewPostAdded extends ProfileEvent {
  final Post post;

  const NewPostAdded(this.post);

  @override
  List<Object> get props => [post];
}


// profile_event.dart
class LoadPreviousPosts extends ProfileEvent {}
