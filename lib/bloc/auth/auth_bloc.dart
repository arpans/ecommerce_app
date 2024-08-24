import 'package:ecommerce_app/bloc/auth/auth_event.dart';
import 'package:ecommerce_app/bloc/auth/auth_state.dart';
import 'package:ecommerce_app/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bloc/cart/cart_event.dart';
import 'package:ecommerce_app/repositories/login_repository.dart';
import 'package:ecommerce_app/repositories/registration_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginRepository loginRepository;
  final RegistrationRepository registrationRepository;
  final CartBloc cartBloc;

  AuthBloc(
      {required this.loginRepository, required this.registrationRepository, required this.cartBloc})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onRegistration);
    on<Logout>((event, emit) async {
      // Handle logout logic here, e.g., clearing tokens, etc.
      emit(AuthLoading());
      try {
        // Call any logout API or remove authentication token

        // Clear the cart when logging out
        cartBloc.add(ClearCart());

        emit(AuthLoggedOut());
      } catch (error) {
        emit(const AuthError('Failed to log out'));
      }
    });
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final login = await loginRepository.doLogin(event.email, event.password);
      if (login["message"] == "Unauthorized") {
        emit(const AuthError("Failed to login"));
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', login["access_token"]);
        emit(AuthAuthenticated());
      }
    } catch (e) {
      emit(const AuthError("Failed to login"));
    }
  }

  Future<void> _onRegistration(
      SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final login = await registrationRepository.doSignUp(
          event.username, event.email, event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(const AuthError("Failed to register"));
    }
  }
}
