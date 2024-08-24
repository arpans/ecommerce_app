import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class Logout extends AuthEvent {}

class SignupEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignupEvent(this.username, this.email, this.password);

  @override
  List<Object?> get props => [username, email, password];
}
