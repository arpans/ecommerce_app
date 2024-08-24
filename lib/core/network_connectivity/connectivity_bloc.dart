import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onChanged);

    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
    //   (result) => add(ConnectivityChanged(result)),
    // );
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        for (var element in result){
          bool isConnected = element != ConnectivityResult.none;
          add(ConnectivityChanged(result, isConnected));
        }
      },
    );
  }

  Future<void> _onStarted(ConnectivityStarted event, Emitter<ConnectivityState> emit) async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // emit(ConnectivityLoadSuccess(result));
      for (var element in result){
        bool isConnected = element != ConnectivityResult.none;
        emit(ConnectivityLoadSuccess(result, isConnected));
      }

    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status:: $e');
    }
  }

  void _onChanged(ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    emit(ConnectivityLoadSuccess(event.result, event.isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}