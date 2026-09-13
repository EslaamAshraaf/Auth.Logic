import 'package:dio/dio.dart';
import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../models/google_login_request_model.dart';
import '../models/apple_login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/verify_registration_request_model.dart';
import '../models/forget_password_request_model.dart';
import '../models/verify_otp_request_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/logout_request_model.dart';
import '../models/change_password_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/update_profile_request_model.dart';

/// Auth service handles all authentication API calls.
/// Uses SecureTokenStorage for token persistence and ApiException for errors.
class AuthService {
  final ApiClient _apiClient;
  final SecureTokenStorage _tokenStorage;

  AuthService({
    required ApiClient apiClient,
    required SecureTokenStorage tokenStorage,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage;

  // ─── Login ───────────────────────────────────────────────

  Future<UserModel> login({
    required String login,
    required String password,
    required String locale,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    try {
      final request = LoginRequestModel(
        login: login,
        password: password,
        locale: locale,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      final response = await _apiClient.post(
        AppEndpoints.login,
        data: request.toJson(),
      );
      final userModel = _parseUser(response);
      await _tokenStorage.saveTokens(accessToken: userModel.token);
      return userModel;
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<UserModel> loginWithGoogle({
    required String idToken,
    required String locale,
    String? phone,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    try {
      final request = GoogleLoginRequestModel(
        idToken: idToken,
        locale: locale,
        phone: phone,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      final response = await _apiClient.post(
        AppEndpoints.googleLogin,
        data: request.toJson(),
      );
      final userModel = _parseUser(response);
      await _tokenStorage.saveTokens(accessToken: userModel.token);
      return userModel;
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<UserModel> loginWithApple({
    required String idToken,
    required String locale,
    String? phone,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    try {
      final request = AppleLoginRequestModel(
        idToken: idToken,
        locale: locale,
        phone: phone,
        fcmToken: fcmToken,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      final response = await _apiClient.post(
        AppEndpoints.appleLogin,
        data: request.toJson(),
      );
      final userModel = _parseUser(response);
      await _tokenStorage.saveTokens(accessToken: userModel.token);
      return userModel;
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  // ─── Register ────────────────────────────────────────────

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
    try {
      final request = RegisterRequestModel(
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
      await _apiClient.post(AppEndpoints.register, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<UserModel> verifyRegistration({
    required String login,
    required String otp,
    required String deviceId,
    required String deviceType,
  }) async {
    try {
      final request = VerifyRegistrationRequestModel(
        login: login,
        otp: otp,
        deviceId: deviceId,
        deviceType: deviceType,
      );
      final response = await _apiClient.post(
        AppEndpoints.verifyRegistration,
        data: request.toJson(),
      );
      final userModel = _parseUser(response);
      await _tokenStorage.saveTokens(accessToken: userModel.token);
      return userModel;
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  // ─── Forgot Password ─────────────────────────────────────

  Future<void> forgetPassword({required String login}) async {
    try {
      final request = ForgetPasswordRequestModel(login: login);
      await _apiClient.post(
        AppEndpoints.forgetPassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<void> verifyOtp({required String login, required String otp}) async {
    try {
      final request = VerifyOtpRequestModel(login: login, otp: otp);
      await _apiClient.post(AppEndpoints.verifyOtp, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<void> resetPassword({
    required String login,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final request = ResetPasswordRequestModel(
        login: login,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      await _apiClient.post(
        AppEndpoints.resetPassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<void> resendOtp({required String login}) async {
    try {
      final request = ResendOtpRequestModel(login: login);
      await _apiClient.post(AppEndpoints.resendOtp, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  // ─── Profile ─────────────────────────────────────────────

  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get(AppEndpoints.getProfile);
      return _parseUser(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<UserModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiClient.post(
        AppEndpoints.updateProfile,
        data: formData,
      );
      return _parseUser(response);
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<void> changePassword(ChangePasswordRequestModel request) async {
    try {
      await _apiClient.post(
        AppEndpoints.changePassword,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  // ─── Logout ──────────────────────────────────────────────

  Future<void> logout({
    required String fcmToken,
    required String deviceId,
  }) async {
    try {
      final request = LogoutRequestModel(fcmToken: fcmToken, deviceId: deviceId);
      await _tokenStorage.clearTokens();
      await _apiClient.post(AppEndpoints.logout, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.from(e);
    } catch (e) {
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }

  // ─── Helpers ─────────────────────────────────────────────

  UserModel _parseUser(Response response) {
    return UserModel.fromJson(response.data['data'] ?? response.data);
  }
}
