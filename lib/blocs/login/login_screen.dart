import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestyle_companion/ui.dart';
import '../login/login_bloc.dart';
import '../login/login_event.dart';
import '../login/login_state.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-login check
    Future.microtask(() {
      context.read<LoginBloc>().add(CheckLoginStatus());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc()..add(CheckLoginStatus()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.success) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => UiWidget()),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        onChanged: (value) =>
                            context.read<LoginBloc>().add(EmailChanged(value)),
                        decoration: InputDecoration(
                          hintText: 'Enter your registered email',
                          errorText: state.emailValid ? null : 'Invalid email',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        onChanged: (value) => context
                            .read<LoginBloc>()
                            .add(PasswordChanged(value)),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          errorText:
                              state.passwordValid ? null : 'Enter password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      state.submitting
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => context
                                  .read<LoginBloc>()
                                  .add(LoginSubmitted()),
                              child: const Text('Login'),
                            ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('OR'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      state.submitting
                          ? const SizedBox()
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Login with Google'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () => context
                                  .read<LoginBloc>()
                                  .add(GoogleLoginSubmitted()),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
