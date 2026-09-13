import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'verify_registration_state.dart';

class VerifyRegistrationViewModel extends Cubit<VerifyRegistrationState> {
  final AuthService _authService;

  VerifyRegistrationViewModel({required AuthService authService})
      : _authService = authService,
        super(const VerifyRegistrationState());

  Future<void> verify({
    required String login,
    required String otp,
    required String deviceId,
    required String deviceType,
  }) async {
    emit(state.copyWith(status: VerifyRegistrationStatus.loading));
    try {
      final user = await _authService.verifyRegistration(
        login: login,
        otp: otp,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      emit(state.copyWith(status: VerifyRegistrationStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: VerifyRegistrationStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VerifyRegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
