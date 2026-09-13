import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/auth_dependencies.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/login_state.dart';

/// MVVM Login Screen
/// View observes LoginViewModel (Cubit) for state changes.
/// ViewModel calls AuthService directly (no usecases).

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(authService: AuthDependencies.create().authService),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginViewModel, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          // TODO: Navigate to your main screen
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Login Screen', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                // TODO: Add your phone/email and password text fields
                // TODO: Add Google and Apple sign-in buttons
                // TODO: Add "Forgot Password?" link
                // TODO: Add "Sign Up" link
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.status == LoginStatus.loading
                      ? null
                      : () {
                          // TODO: Call login with your text field values
                          // context.read<LoginViewModel>().login(
                          //   login: phoneOrEmail,
                          //   password: password,
                          //   locale: 'en',
                          //   fcmToken: await FcmHelper.getToken(),
                          //   deviceId: await DeviceHelper.getDeviceId(),
                          //   deviceType: DeviceHelper.getDeviceType(),
                          // );
                        },
                  child: state.status == LoginStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Sign In'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
