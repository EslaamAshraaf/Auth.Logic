import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'resend_otp_state.dart';

class ResendOtpViewModel extends Cubit<ResendOtpState> {
  final AuthService _authService;

  ResendOtpViewModel({required AuthService authService})
      : _authService = authService,
        super(const ResendOtpState());

  Future<void> resendOtp({required String login}) async {
    emit(state.copyWith(status: ResendOtpStatus.loading));
    try {
      await _authService.resendOtp(login: login);
      emit(state.copyWith(status: ResendOtpStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ResendOtpStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: ResendOtpStatus.failure, errorMessage: e.toString()));
    }
  }
}
