part of 'timeline_bloc.dart';

abstract class TimelineEvent extends Equatable {
  const TimelineEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToTimeline extends TimelineEvent {}

class LoadTimeline extends TimelineEvent {
  final List<Post> posts;

  const LoadTimeline({required this.posts});

  @override
  List<Object> get props => [posts];
}

class UpdatedTimeline extends TimelineEvent {
  final Post post;

  const UpdatedTimeline({required this.post});

  @override
  List<Object> get props => [post];
}

class TimeLineError extends TimelineEvent {
  final String message;

  const TimeLineError({required this.message});

  @override
  List<Object> get props => [message];
}

class RefreshTimeline extends TimelineEvent {}
