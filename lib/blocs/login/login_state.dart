class LoginState {
  final String email;
  final String password;
  final bool emailValid;
  final bool passwordValid;
  final bool submitting;
  final bool success;


  LoginState( {
    this.email = "",
    this.password = "",
    this.emailValid = true,
    this.passwordValid = true,
    this.submitting = false,
    this.success = false
  });


  LoginState copyWith({// COPY WITH ALLOWS YOU TO CREATE A NEW INSTANCE OF A CLASS BY CHANGING ONLY CERTAIN FIELDS, WHILE KEEPING THE REST UNCHANGED
    String? email,
    String? password,
    bool? emailValid,
    bool? passwordValid,
    bool? submitting,
    bool? success,
  }) => LoginState(
    email: email ?? this.email,
    password:  password ?? this.password,
    emailValid: emailValid ?? this.emailValid,
     passwordValid: passwordValid ?? this.passwordValid,
        submitting: submitting ?? this.submitting,
        success: success ?? this.success,

  );



}