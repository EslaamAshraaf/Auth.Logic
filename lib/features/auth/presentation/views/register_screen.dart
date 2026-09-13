import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/auth_dependencies.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../../viewmodels/register_state.dart';

/// MVVM Register Screen
/// View observes RegisterViewModel for state changes.

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterViewModel(authService: AuthDependencies.create().authService),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterViewModel, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          // TODO: Navigate to OTP verification screen
          // Navigator.push(context, MaterialPageRoute(builder: (_) => OtpVerificationScreen(phone: normalizedPhone)));
        } else if (state.status == RegisterStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Registration failed')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Register Screen', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                // TODO: Add text fields for: name, email, phone, password, confirm password
                // TODO: Add terms & conditions checkbox
                // TODO: Add "Sign Up" button
                // TODO: Add "Already have account? Sign In" link
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.status == RegisterStatus.loading
                      ? null
                      : () {
                          // TODO: Call register with your text field values
                        },
                  child: state.status == RegisterStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Up'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
