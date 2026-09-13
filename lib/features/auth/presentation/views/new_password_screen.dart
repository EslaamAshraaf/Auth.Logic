import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/auth_dependencies.dart';
import '../../viewmodels/reset_password_viewmodel.dart';
import '../../viewmodels/reset_password_state.dart';

/// MVVM New Password Screen
/// View observes ResetPasswordViewModel for state changes.

class NewPasswordScreen extends StatelessWidget {
  final String login;
  final String otp;

  const NewPasswordScreen({super.key, required this.login, required this.otp});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordViewModel(
        authService: AuthDependencies.create().authService,
      ),
      child: _NewPasswordView(login: login, otp: otp),
    );
  }
}

class _NewPasswordView extends StatelessWidget {
  final String login;
  final String otp;

  const _NewPasswordView({required this.login, required this.otp});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          // TODO: Show success dialog, then navigate to login screen
        } else if (state.status == ResetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Failed to reset password')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New Password', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                // TODO: Add new password text field
                // TODO: Add confirm password text field
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.status == ResetPasswordStatus.loading
                      ? null
                      : () {
                          // TODO: Validate passwords match, then call resetPassword
                        },
                  child: state.status == ResetPasswordStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Create New Password'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
