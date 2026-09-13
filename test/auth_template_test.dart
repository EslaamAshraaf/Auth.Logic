import 'package:flutter_test/flutter_test.dart';
import 'package:auth_template/core/network/api_client.dart';
import 'package:auth_template/core/storage/shared_prefs_token_storage.dart';
import 'package:auth_template/features/auth/services/auth_service.dart';
import 'package:auth_template/features/auth/viewmodels/login_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/login_state.dart';
import 'package:auth_template/features/auth/viewmodels/register_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/register_state.dart';
import 'package:auth_template/features/auth/viewmodels/forget_password_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/forget_password_state.dart';
import 'package:auth_template/features/auth/viewmodels/verify_otp_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/verify_otp_state.dart';
import 'package:auth_template/features/auth/viewmodels/verify_registration_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/verify_registration_state.dart';
import 'package:auth_template/features/auth/viewmodels/resend_otp_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/resend_otp_state.dart';
import 'package:auth_template/features/auth/viewmodels/reset_password_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/reset_password_state.dart';
import 'package:auth_template/features/auth/viewmodels/logout_viewmodel.dart';
import 'package:auth_template/features/auth/viewmodels/logout_state.dart';
import 'package:auth_template/features/auth/models/user_model.dart';
import 'package:auth_template/features/auth/models/login_request_model.dart';
import 'package:auth_template/features/auth/models/register_request_model.dart';
import 'package:auth_template/features/auth/models/forget_password_request_model.dart';
import 'package:auth_template/features/auth/models/verify_otp_request_model.dart';
import 'package:auth_template/features/auth/models/reset_password_request_model.dart';
import 'package:auth_template/features/auth/models/logout_request_model.dart';

void main() {
  // Helper to create dependencies
  AuthService createAuthService() {
    final tokenStorage = SharedPrefsTokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    return AuthService(apiClient: apiClient, tokenStorage: tokenStorage);
  }

  group('AuthService', () {
    test('can be instantiated', () {
      final service = createAuthService();
      expect(service, isNotNull);
    });
  });

  group('LoginViewModel', () {
    test('initial state is LoginStatus.initial', () {
      final vm = LoginViewModel(authService: createAuthService());
      expect(vm.state.status, LoginStatus.initial);
      expect(vm.state.user, isNull);
      expect(vm.state.errorMessage, isNull);
    });

    test('copyWith works correctly', () {
      const state = LoginState();
      final user = UserModel(id: 1, name: 'Test', email: 'test@test.com', token: 'abc');

      final updated = state.copyWith(
        status: LoginStatus.success,
        user: user,
      );

      expect(updated.status, LoginStatus.success);
      expect(updated.user?.name, 'Test');
      expect(updated.user?.token, 'abc');
    });

    test('copyWith preserves values when not provided', () {
      const state = LoginState(
        status: LoginStatus.failure,
        errorMessage: 'error',
      );
      final updated = state.copyWith(status: LoginStatus.initial);
      expect(updated.errorMessage, 'error');
    });
  });

  group('RegisterViewModel', () {
    test('initial state is RegisterStatus.initial', () {
      final vm = RegisterViewModel(authService: createAuthService());
      expect(vm.state.status, RegisterStatus.initial);
    });

    test('copyWith works correctly', () {
      const state = RegisterState();
      final updated = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Email taken',
      );
      expect(updated.status, RegisterStatus.failure);
      expect(updated.errorMessage, 'Email taken');
    });
  });

  group('ForgetPasswordViewModel', () {
    test('initial state is ForgetPasswordStatus.initial', () {
      final vm = ForgetPasswordViewModel(authService: createAuthService());
      expect(vm.state.status, ForgetPasswordStatus.initial);
    });
  });

  group('VerifyOtpViewModel', () {
    test('initial state is VerifyOtpStatus.initial', () {
      final vm = VerifyOtpViewModel(authService: createAuthService());
      expect(vm.state.status, VerifyOtpStatus.initial);
    });
  });

  group('VerifyRegistrationViewModel', () {
    test('initial state is VerifyRegistrationStatus.initial', () {
      final vm = VerifyRegistrationViewModel(authService: createAuthService());
      expect(vm.state.status, VerifyRegistrationStatus.initial);
    });
  });

  group('ResendOtpViewModel', () {
    test('initial state is ResendOtpStatus.initial', () {
      final vm = ResendOtpViewModel(authService: createAuthService());
      expect(vm.state.status, ResendOtpStatus.initial);
    });
  });

  group('ResetPasswordViewModel', () {
    test('initial state is ResetPasswordStatus.initial', () {
      final vm = ResetPasswordViewModel(authService: createAuthService());
      expect(vm.state.status, ResetPasswordStatus.initial);
    });
  });

  group('LogoutViewModel', () {
    test('initial state is LogoutStatus.initial', () {
      final vm = LogoutViewModel(authService: createAuthService());
      expect(vm.state.status, LogoutStatus.initial);
    });
  });

  group('UserModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'token': 'my_token',
        'app_user': {
          'id': 42,
          'full_name': 'John Doe',
          'user_name': 'john_doe',
          'email': 'john@example.com',
          'phone': '+1234567890',
          'avatar': 'https://example.com/avatar.jpg',
          'locale': 'en',
          'gender': 'male',
          'date_of_birth': '1990-01-01',
        },
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 42);
      expect(user.name, 'John Doe');
      expect(user.userName, 'john_doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '+1234567890');
      expect(user.token, 'my_token');
      expect(user.profileImage, 'https://example.com/avatar.jpg');
      expect(user.locale, 'en');
      expect(user.gender, 'male');
      expect(user.dateOfBirth, '1990-01-01');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'token': 'token',
        'app_user': {
          'id': 1,
          'full_name': 'Test',
          'email': 'test@test.com',
        },
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Test');
      expect(user.phone, isNull);
      expect(user.userName, isNull);
      expect(user.profileImage, isNull);
    });

    test('toJson serializes correctly', () {
      const user = UserModel(
        id: 1,
        name: 'Test',
        email: 'test@test.com',
        token: 'abc',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test');
      expect(json['email'], 'test@test.com');
      expect(json['token'], 'abc');
    });
  });

  group('ApiException', () {
    test('toString formats correctly', () {
      const ex = ApiException(statusCode: 401, message: 'Unauthorized');
      expect(ex.toString(), 'ApiException(401): Unauthorized');
      expect(ex.isUnauthorized, isTrue);
      expect(ex.isValidationError, isFalse);
    });

    test('isValidationError works', () {
      const ex = ApiException(statusCode: 422, message: 'Invalid');
      expect(ex.isValidationError, isTrue);
    });

    test('isNotFound works', () {
      const ex = ApiException(statusCode: 404, message: 'Not found');
      expect(ex.isNotFound, isTrue);
    });
  });

  group('Request Models', () {
    test('LoginRequestModel toJson', () {
      final model = LoginRequestModel(
        login: '+123',
        password: 'pass',
        locale: 'en',
        fcmToken: 'fcm',
        deviceId: 'device',
        deviceType: 'android',
      );
      final json = model.toJson();
      expect(json['login'], '+123');
      expect(json['password'], 'pass');
    });

    test('RegisterRequestModel toJson', () {
      final model = RegisterRequestModel(
        fullName: 'John',
        userName: 'john',
        email: 'john@test.com',
        phone: '+123',
        password: 'pass',
        passwordConfirmation: 'pass',
        locale: 'en',
        fcmToken: 'fcm',
        deviceId: 'device',
        deviceType: 'ios',
      );
      final json = model.toJson();
      expect(json['full_name'], 'John');
      expect(json['user_name'], 'john');
    });

    test('ForgetPasswordRequestModel toJson', () {
      final model = ForgetPasswordRequestModel(login: '+123');
      expect(model.toJson(), {'login': '+123'});
    });

    test('VerifyOtpRequestModel toJson', () {
      final model = VerifyOtpRequestModel(login: '+123', otp: '1234');
      expect(model.toJson(), {'login': '+123', 'otp': '1234'});
    });

    test('ResetPasswordRequestModel toJson', () {
      final model = ResetPasswordRequestModel(
        login: '+123',
        otp: '1234',
        password: 'newpass',
        passwordConfirmation: 'newpass',
      );
      final json = model.toJson();
      expect(json['password'], 'newpass');
    });

    test('LogoutRequestModel toJson', () {
      final model = LogoutRequestModel(fcmToken: 'fcm', deviceId: 'device');
      expect(model.toJson(), {'fcm_token': 'fcm', 'device_id': 'device'});
    });
  });
}
