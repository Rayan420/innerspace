part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}


class InternetStatusChanged extends InternetEvent {
  final ConnectivityResult status;

  const InternetStatusChanged(this.status);
}