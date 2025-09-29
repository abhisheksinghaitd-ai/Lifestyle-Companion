import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Box loginBox = Hive.box('login');

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  LoginBloc() : super(LoginState()) {
    // Email field change
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(
        email: event.email,
        emailValid: event.email.contains('@'),
      ));
    });

    // Password field change
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(
        password: event.password,
        passwordValid: event.password.isNotEmpty,
      ));
    });

    // Email/Password login
    on<LoginSubmitted>((event, emit) async {
      final emailValid = state.email.contains('@');
      final passwordValid = state.password.isNotEmpty;

      // Update validation flags
      emit(state.copyWith(emailValid: emailValid, passwordValid: passwordValid));

      if (!emailValid || !passwordValid) return;

      emit(state.copyWith(submitting: true, success: false));

      await Future.delayed(Duration(seconds: 1)); // simulate delay

      // Save login info to Hive (consistent key)
      await loginBox.put('user', {'email': state.email, 'password': state.password});

      emit(state.copyWith(submitting: false, success: true));
    });

    // Check for auto-login
    on<CheckLoginStatus>((event, emit) async {
      final user = loginBox.get('user');
      if (user != null && (user['email'] != null)) {
        emit(state.copyWith(success: true));
      }
    });

    // Google login
    on<GoogleLoginSubmitted>((event, emit) async {
      emit(state.copyWith(submitting: true));

      try {
        final GoogleSignInAccount? account = await _googleSignIn.signIn();

        if (account != null) {
          await loginBox.put('user', {
            'email': account.email,
            'name': account.displayName ?? '',
            'google': true,
          });

          emit(state.copyWith(submitting: false, success: true));
        } else {
          emit(state.copyWith(submitting: false, success: false));
        }
      } catch (e) {
        emit(state.copyWith(submitting: false, success: false));
      }
    });
  }
}
