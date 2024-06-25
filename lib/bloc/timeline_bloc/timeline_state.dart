// timeline_state.dart

part of 'timeline_bloc.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object> get props => [];
}

class TimelineSubscribed extends TimelineState {}

class TimelineSubscribeError extends TimelineState {
  final String message;

  const TimelineSubscribeError({required this.message});

  @override
  List<Object> get props => [message];
}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<Post> posts;
  final List<Post?> newPosts; // Added newPosts field

  const TimelineLoaded({
    required this.posts,
    this.newPosts = const [],
  });

  @override
  List<Object> get props => [posts, newPosts]; // Include newPosts in props
}

class TimelineEmpty extends TimelineState {
  const TimelineEmpty();

  @override
  List<Object> get props => [];
}

class TimelineNewPostAvailable extends TimelineState {}

class TimelineError extends TimelineState {
  final String message;

  const TimelineError({required this.message});

  @override
  List<Object> get props => [message];
}
