abstract class LoginEvent {}

class EmailChanged extends LoginEvent{
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends LoginEvent{
  final String password;
  PasswordChanged(this.password);
}

class LoginSubmitted extends LoginEvent {}

/// New event: Check if user is already logged in
class CheckLoginStatus extends LoginEvent {}

class GoogleLoginSubmitted extends LoginEvent{}