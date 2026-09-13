import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_template/core/network/api_client.dart';
import '../services/auth_service.dart';
import 'reset_password_state.dart';

class ResetPasswordViewModel extends Cubit<ResetPasswordState> {
  final AuthService _authService;

  ResetPasswordViewModel({required AuthService authService})
      : _authService = authService,
        super(const ResetPasswordState());

  Future<void> resetPassword({
    required String login,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      await _authService.resetPassword(
        login: login,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(state.copyWith(status: ResetPasswordStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
