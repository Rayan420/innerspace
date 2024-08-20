// profile_bloc.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final TimelineRepository _timelineRepository;
  StreamSubscription<User>? _userSubscription;
  StreamSubscription<Post>? _newPostSubscription;

  ProfileBloc(
      {required this.userRepository,
      required TimelineRepository timelineRepository})
      : _timelineRepository = timelineRepository,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<_UserProfileChanged>(_onUserProfileChanged);
    on<UpdateProfile>(_onUpdateProfile);
    on<NewPostAdded>(_onNewPostAdded);
    on<LoadPreviousPosts>(_onLoadPreviousPosts);

    _userSubscription = userRepository.userStream.listen(
      (user) => add(_UserProfileChanged(user)),
    );

    _newPostSubscription = _timelineRepository.newPostStream.listen(
      (post) => add(NewPostAdded(post)),
    );
  }
  void _onLoadPreviousPosts(
      LoadPreviousPosts event, Emitter<ProfileState> emit) async {
    try {
      final previousPosts = await _timelineRepository.loadOwnPosts();
      emit(ProfilePreviousPostsLoaded(previousPosts));
    } catch (e) {
      emit(ProfileError("Failed to load previous posts"));
    }
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await userRepository.fetchUserProfile();
      final posts = await _timelineRepository.loadOwnPosts();
      emit(ProfileLoaded(user, posts: posts));
    } catch (e) {
      emit(const ProfileError("Failed to load profile"));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      await userRepository.updateUserProfile(
        event.firstName,
        event.lastName,
        event.bio,
        event.profilePicture,
        event.coverPicture,
      );
      final updatedUser = await userRepository.fetchUserProfile();
      final posts = await _timelineRepository.loadOwnPosts();
      emit(ProfileLoaded(updatedUser, posts: posts));
    } catch (e) {
      emit(ProfileError("Failed to update profile"));
    }
  }

  void _onUserProfileChanged(
      _UserProfileChanged event, Emitter<ProfileState> emit) async {
    final posts = await _timelineRepository.loadOwnPosts();

    emit(ProfileLoaded(event.user, posts: posts));
  }

  void _onNewPostAdded(NewPostAdded event, Emitter<ProfileState> emit) {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      final updatedPosts = List<Post>.from(currentState.posts)..add(event.post);
      emit(ProfileLoaded(currentState.user, posts: updatedPosts));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _newPostSubscription?.cancel();
    return super.close();
  }
}
