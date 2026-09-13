import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'register_state.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterViewModel({required AuthService authService})
      : _authService = authService,
        super(const RegisterState());

  Future<void> register({
    required String fullName,
    required String userName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String locale,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      await _authService.register(
        fullName: fullName,
        userName: userName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        locale: locale,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      emit(state.copyWith(status: RegisterStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
