import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'verify_otp_state.dart';

class VerifyOtpViewModel extends Cubit<VerifyOtpState> {
  final AuthService _authService;

  VerifyOtpViewModel({required AuthService authService})
      : _authService = authService,
        super(const VerifyOtpState());

  Future<void> verifyOtp({required String login, required String otp}) async {
    emit(state.copyWith(status: VerifyOtpStatus.loading));
    try {
      await _authService.verifyOtp(login: login, otp: otp);
      emit(state.copyWith(status: VerifyOtpStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: VerifyOtpStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: VerifyOtpStatus.failure, errorMessage: e.toString()));
    }
  }
}
