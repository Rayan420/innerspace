import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final TimelineRepository _timelineRepository;
  TimelineBloc(
    this._timelineRepository,
  ) : super(TimelineLoading()) {}
}
