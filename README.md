# auth_logic

A production-ready authentication package for Flutter apps. Login, register, forgot password, OTP verification, token refresh, and more — all wired up with MVVM + Cubit.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  auth_logic: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Import the package

```dart
import 'package:auth_logic/auth_logic.dart';
```

### 2. Update base URL

```dart
// In your app's initialization code
AppEndpoints.baseUrl = 'https://your-api.com';
```

### 3. Use in your widget

```dart
BlocProvider(
  create: (_) => LoginViewModel(
    authService: AuthDependencies.create().authService,
  ),
  child: BlocConsumer<LoginViewModel, LoginState>(
    listener: (context, state) {
      if (state.status == LoginStatus.success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    },
    builder: (context, state) {
      return YourCustomLoginForm(
        isLoading: state.status == LoginStatus.loading,
        onLogin: (phone, password) {
          context.read<LoginViewModel>().login(
            login: phone,
            password: password,
            locale: 'en',
            fcmToken: await FcmHelper.getToken(),
            deviceId: await DeviceHelper.getDeviceId(),
            deviceType: DeviceHelper.getDeviceType(),
          );
        },
      );
    },
  ),
)
```

## Features

- **Login** — Phone/Email + Password, Google Sign-In, Apple Sign-In
- **Register** — Full registration flow with OTP verification
- **Forgot Password** — Send OTP → Verify → Reset password
- **Token Management** — Auto-inject, auto-refresh on 401, auto-clear
- **Retry Logic** — Auto-retry on connection errors (3 attempts with backoff)
- **Colored Logs** — ANSI-colored network logs in terminal
- **Error Handling** — Structured `ApiException` with status codes

## ViewModels

| ViewModel | Methods |
|-----------|---------|
| `LoginViewModel` | `.login()`, `.loginWithGoogle()`, `.loginWithApple()` |
| `RegisterViewModel` | `.register()` |
| `VerifyRegistrationViewModel` | `.verify()` |
| `ForgetPasswordViewModel` | `.forgetPassword()` |
| `VerifyOtpViewModel` | `.verifyOtp()` |
| `ResendOtpViewModel` | `.resendOtp()` |
| `ResetPasswordViewModel` | `.resetPassword()` |
| `LogoutViewModel` | `.logout()` |

## Custom Token Storage

By default, tokens are stored in `SharedPreferences`. For production, use `flutter_secure_storage`:

```dart
class SecureTokenStorageImpl implements SecureTokenStorage {
  final _storage = FlutterSecureStorage();

  @override
  Future<String?> get accessToken => _storage.read(key: 'access_token');

  @override
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  @override
  Future<void> clearTokens() => _storage.deleteAll();
}

// Use custom storage
final deps = AuthDependencies.createWith(tokenStorage: SecureTokenStorageImpl());
```

## License

MIT
