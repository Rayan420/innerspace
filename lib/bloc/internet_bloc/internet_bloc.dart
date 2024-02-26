import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  late final StreamSubscription<ConnectivityResult> _connectivitySubscription;

  InternetBloc() : super(const InternetState.unknown()) {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((status) {
      add(InternetStatusChanged(status));
    });

    // Handle initial connectivity state
    _initializeConnectivity();

    on<InternetStatusChanged>((event, emit) {
      if (event.status == ConnectivityResult.wifi ||
          event.status == ConnectivityResult.mobile) {
        emit(const InternetState.connected());
      } else {
        emit(const InternetState.disconnected());
      }
    });
  }

  Future<void> _initializeConnectivity() async {
    try {
      final status = await Connectivity().checkConnectivity();
      add(InternetStatusChanged(status));
    } catch (e) {
      // Handle error if needed
    }
  }

  bool isConnected() {
    return state.status == InternetStatus.connected;
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
