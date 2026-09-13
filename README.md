# Auth Template — MVVM + Cubit

A production-ready authentication template for Flutter. Copy, connect your UI, ship.

## Architecture

```
View (Screen) → ViewModel (Cubit) → AuthService → API
```

MVVM with Cubit state management. Clean, simple, no over-engineering.

## Features

- **Login** — Phone/Email + Password, Google Sign-In, Apple Sign-In
- **Register** — Full registration flow with OTP verification
- **Forgot Password** — Send OTP → Verify → Reset password
- **Token Management** — Auto-inject, auto-refresh on 401, auto-clear
- **Retry Logic** — Auto-retry on connection errors (3 attempts with backoff)
- **Colored Logs** — ANSI-colored network logs in terminal
- **Error Handling** — Structured `ApiException` with status codes

## What's Included

```
lib/
├── core/
│   ├── constants/        — API endpoints
│   ├── network/          — ApiClient, interceptors, ApiException
│   ├── storage/          — SecureTokenStorage abstraction
│   ├── di/               — Dependency injection factory
│   └── utils/            — Phone helper, device info, FCM, country codes
└── features/auth/
    ├── models/           — Request/response data classes (13 models)
    ├── services/         — AuthService (all API calls)
    ├── viewmodels/       — 8 Cubits (Login, Register, OTP, Password, Logout)
    └── views/            — Reference screens (replace with your UI)
```

## Quick Start

### 1. Copy to your project

```bash
cp -r lib/core/ your_project/lib/core/
cp -r lib/features/auth/ your_project/lib/features/auth/
```

### 2. Add dependencies

```yaml
dependencies:
  shared_preferences: ^2.5.5
  dio: ^5.11.0
  flutter_bloc: ^9.1.1
  equatable: ^2.1.0
  phone_numbers_parser: ^8.0.0
  device_info_plus: ^13.2.0
  firebase_core: ^4.13.0
  firebase_messaging: ^16.5.0
  google_sign_in: ^7.2.0        # optional
  sign_in_with_apple: ^8.1.0    # optional
  image_picker: ^1.2.3          # optional
```

### 3. Update base URL

```dart
// lib/core/constants/app_endpoints.dart
static const String baseUrl = 'https://your-api.com';
```

### 4. Use in your screen

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

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/app/auth/login` | POST | Login |
| `/api/app-user/auth/google/token` | POST | Google login |
| `/api/app-user/auth/apple/token` | POST | Apple login |
| `/api/app/auth/register` | POST | Register |
| `/api/app/auth/verify-registration` | POST | Verify registration OTP |
| `/api/app/auth/forget-password` | POST | Send forgot password OTP |
| `/api/app/auth/verify-otp` | POST | Verify OTP |
| `/api/app/auth/resend-otp` | POST | Resend OTP |
| `/api/app/auth/reset-password` | POST | Reset password |
| `/api/app/auth/logout` | POST | Logout |
| `/api/app/auth/me` | GET | Get current user |
| `/api/app/auth/update-profile` | POST | Update profile |
| `/api/app/auth/change-password` | POST | Change password |

## Token Storage

Default: `SharedPreferences`. Swap to `flutter_secure_storage` for production:

```dart
class SecureTokenStorageImpl extends SecureTokenStorage {
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
