import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'login_state.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthService _authService;

  LoginViewModel({required AuthService authService})
      : _authService = authService,
        super(const LoginState());

  Future<void> login({
    required String login,
    required String password,
    required String locale,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authService.login(
        login: login,
        password: password,
        locale: locale,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loginWithGoogle({
    required String idToken,
    required String locale,
    String? phone,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authService.loginWithGoogle(
        idToken: idToken,
        locale: locale,
        phone: phone,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> loginWithApple({
    required String idToken,
    required String locale,
    String? phone,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authService.loginWithApple(
        idToken: idToken,
        locale: locale,
        phone: phone,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } on ApiException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
