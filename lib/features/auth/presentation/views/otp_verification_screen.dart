import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/auth_dependencies.dart';
import '../../viewmodels/verify_registration_viewmodel.dart';
import '../../viewmodels/verify_otp_viewmodel.dart';
import '../../viewmodels/resend_otp_viewmodel.dart';

/// MVVM OTP Verification Screen
/// Shared between registration and forgot password flows.

enum OtpFlow { registration, forgotPassword }

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final OtpFlow flow;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.flow,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthDependencies.create().authService;

    if (flow == OtpFlow.registration) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => VerifyRegistrationViewModel(authService: authService)),
          BlocProvider(create: (_) => ResendOtpViewModel(authService: authService)),
        ],
        child: _OtpView(phoneNumber: phoneNumber, flow: flow),
      );
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => VerifyOtpViewModel(authService: authService)),
          BlocProvider(create: (_) => ResendOtpViewModel(authService: authService)),
        ],
        child: _OtpView(phoneNumber: phoneNumber, flow: flow),
      );
    }
  }
}

class _OtpView extends StatefulWidget {
  final String phoneNumber;
  final OtpFlow flow;

  const _OtpView({required this.phoneNumber, required this.flow});

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  Timer? _timer;
  int _secondsRemaining = 60;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('Verify OTP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Enter the 4-digit code sent to ${widget.phoneNumber}'),
              const SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  _currentOtp = value;
                  if (value.length == 4) _verifyOtp();
                },
                decoration: const InputDecoration(hintText: 'Enter 4-digit OTP', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              _secondsRemaining > 0
                  ? Text('Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}')
                  : GestureDetector(
                      onTap: () {
                        context.read<ResendOtpViewModel>().resendOtp(login: widget.phoneNumber);
                        _startTimer();
                      },
                      child: const Text("Didn't receive code? Resend", style: TextStyle(color: Colors.blue)),
                    ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _currentOtp.length == 4 ? _verifyOtp : null,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp() async {
    const deviceId = 'TODO_DEVICE_ID';
    const deviceType = 'TODO_DEVICE_TYPE';

    if (widget.flow == OtpFlow.registration) {
      context.read<VerifyRegistrationViewModel>().verify(
        login: widget.phoneNumber,
        otp: _currentOtp,
        deviceId: deviceId,
        deviceType: deviceType,
      );
    } else {
      context.read<VerifyOtpViewModel>().verifyOtp(
        login: widget.phoneNumber,
        otp: _currentOtp,
      );
    }
  }
}
