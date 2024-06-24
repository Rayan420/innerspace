part of 'timeline_bloc.dart';

sealed class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object> get props => [];
}

final class TimelineLoading extends TimelineState {}

final class TimelineLoaded extends TimelineState {
  final List<Post> posts;

  TimelineLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

final class TimelineError extends TimelineState {
  final String message;

  TimelineError({required this.message});

  @override
  List<Object> get props => [message];
}

final class TimelineUpdated extends TimelineState {
  final Post post;

  TimelineUpdated({required this.post});

  @override
  List<Object> get props => [post];
}
