import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/auth_dependencies.dart';
import '../../viewmodels/forget_password_viewmodel.dart';
import '../../viewmodels/forget_password_state.dart';

/// MVVM Forgot Password Screen
/// View observes ForgetPasswordViewModel for state changes.

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordViewModel(
        authService: AuthDependencies.create().authService,
      ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        if (state.status == ForgetPasswordStatus.success) {
          // TODO: Navigate to OTP verification screen
        } else if (state.status == ForgetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Failed to send OTP')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Forgot Password', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                // TODO: Add phone number input field
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.status == ForgetPasswordStatus.loading
                      ? null
                      : () {
                          // TODO: Call forgetPassword
                        },
                  child: state.status == ForgetPasswordStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
