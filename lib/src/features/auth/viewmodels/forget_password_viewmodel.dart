import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';
import 'forget_password_state.dart';

class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  final AuthService _authService;

  ForgetPasswordViewModel({required AuthService authService})
      : _authService = authService,
        super(const ForgetPasswordState());

  Future<void> forgetPassword({required String login}) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading));
    try {
      await _authService.forgetPassword(login: login);
      emit(state.copyWith(status: ForgetPasswordStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgetPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
