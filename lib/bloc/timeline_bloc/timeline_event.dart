part of 'timeline_bloc.dart';

sealed class TimelineEvent extends Equatable {
  const TimelineEvent();

  @override
  List<Object> get props => [];
}

class TimeLineLoaded extends TimelineEvent {
  final List<Post> posts;

  TimeLineLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class TimeLineUpdated extends TimelineEvent {
  final Post post;

  TimeLineUpdated({required this.post});

  @override
  List<Object> get props => [post];
}

class TimeLineError extends TimelineEvent {
  final String message;

  TimeLineError({required this.message});

  @override
  List<Object> get props => [message];
}
