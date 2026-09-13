import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_template/core/network/api_client.dart';
import '../services/auth_service.dart';
import 'logout_state.dart';

class LogoutViewModel extends Cubit<LogoutState> {
  final AuthService _authService;

  LogoutViewModel({required AuthService authService})
      : _authService = authService,
        super(const LogoutState());

  Future<void> logout({
    required String fcmToken,
    required String deviceId,
  }) async {
    emit(state.copyWith(status: LogoutStatus.loading));
    try {
      await _authService.logout(fcmToken: fcmToken, deviceId: deviceId);
      emit(state.copyWith(status: LogoutStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LogoutStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LogoutStatus.failure, errorMessage: e.toString()));
    }
  }
}
