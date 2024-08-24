import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityLoadSuccess extends ConnectivityState {
  final List<ConnectivityResult> result;
  final bool isConnected;

  const ConnectivityLoadSuccess(this.result, this.isConnected);

  @override
  List<Object> get props => [result, isConnected];
}