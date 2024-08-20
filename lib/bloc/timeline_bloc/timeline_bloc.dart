import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final TimelineRepository _timelineRepository;
  late StreamSubscription<List<Post>> _initialSubscription;
  late StreamSubscription<Post> _newPostSubscription;

  TimelineBloc({required TimelineRepository timelineRepository})
      : _timelineRepository = timelineRepository,
        super(TimelineLoading()) {
    on<SubscribeToTimeline>(_onSubscribeToTimeline);
    on<LoadTimeline>(_onLoadTimeline);
    on<UpdatedTimeline>(_onUpdatedTimeline);
    on<TimeLineError>(_onTimeLineError);
    on<RefreshTimeline>(_onRefreshTimeline);

    // Subscribe to the initial posts stream
    _initialSubscription = _timelineRepository.initialPostsStream.listen(
      (posts) {
        if (posts.isEmpty || posts == null) {
          // Handle case where initial posts list is empty
          add(const LoadTimeline(posts: [])); // Emit an empty list
        } else {
          add(LoadTimeline(posts: posts));
        }
        // Close the initial posts stream after loading
        _initialSubscription.cancel();
      },
      onError: (error) {
        add(TimeLineError(message: error.toString()));
      },
    );

    // Subscribe to the new post stream
    _newPostSubscription = _timelineRepository.newPostStream.listen(
      (post) {
        add(UpdatedTimeline(post: post));
      },
      onError: (error) {
        add(TimeLineError(message: error.toString()));
      },
    );
  }

  void _onSubscribeToTimeline(
      SubscribeToTimeline event, Emitter<TimelineState> emit) {
    try {
      _timelineRepository.subscribeToTimelineSSE();
      emit(TimelineSubscribed());
      emit(TimelineLoading());
    } catch (e) {
      emit(TimelineSubscribeError(message: e.toString()));
    }
  }

  void _onLoadTimeline(LoadTimeline event, Emitter<TimelineState> emit) {
    if (event.posts.isEmpty || event.posts == null) {
      emit(const TimelineLoaded(posts: [], newPosts: []));
    } else {
      emit(TimelineLoaded(posts: event.posts, newPosts: const []));
    }
  }

  void _onUpdatedTimeline(UpdatedTimeline event, Emitter<TimelineState> emit) {
    if (state is TimelineLoaded) {
      final currentPosts = (state as TimelineLoaded).posts;
      final newPosts = List<Post>.from((state as TimelineLoaded).newPosts)
        ..add(event.post);
      emit(TimelineLoaded(posts: currentPosts, newPosts: newPosts));
    }
  }

  void _onTimeLineError(TimeLineError event, Emitter<TimelineState> emit) {
    emit(TimelineError(message: event.message));
  }

  void _onRefreshTimeline(RefreshTimeline event, Emitter<TimelineState> emit) {
    if (state is TimelineLoaded) {
      final allPosts = List<Post>.from((state as TimelineLoaded).newPosts)
        ..addAll((state as TimelineLoaded).posts);
      emit(TimelineLoaded(
          posts: allPosts,
          newPosts: const [])); // Ensure newPosts is initialized
    }
  }

  @override
  Future<void> close() {
    _initialSubscription.cancel();
    _newPostSubscription.cancel();
    return super.close();
  }
}
