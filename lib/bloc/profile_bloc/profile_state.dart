// profile_state.dart
part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final List<Post> posts;

  const ProfileLoaded(this.user, {this.posts = const []});

  @override
  List<Object> get props => [user, posts];
}


class ProfileUpdated extends ProfileState {
  const ProfileUpdated();

  @override
  List<Object> get props => [];
}

class ProfileUpdateCancelled extends ProfileState {
  const ProfileUpdateCancelled();

  @override
  List<Object> get props => [];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileNewPost extends ProfileState {
  final Post post;

  const ProfileNewPost(this.post);

  @override
  List<Object> get props => [post];
}
class ProfilePreviousPostsLoaded extends ProfileState {
  final List<Post> posts;

  ProfilePreviousPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}


