part of 'internet_bloc.dart';

enum InternetStatus { connected, disconnected, unknown }

class InternetState extends Equatable {
  final InternetStatus status;
  final String? message;

  const InternetState._({this.status = InternetStatus.unknown, this.message});

  const InternetState.unknown() : this._();

  const InternetState.connected() : this._(status: InternetStatus.connected);

  const InternetState.disconnected()
      : this._(
            status: InternetStatus.disconnected,
            message: 'No Internet Connection');

  @override
  List<Object> get props => [status];
}
