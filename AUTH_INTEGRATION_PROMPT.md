# Auth Template Integration Prompt (MVVM + Cubit)

## Architecture

```
View (Screen) → ViewModel (Cubit) → AuthService → API
```

| Layer | Role | Files |
|-------|------|-------|
| **View** | UI widgets, observes ViewModel state | `presentation/views/*.dart` |
| **ViewModel** | State + business logic (Cubit) | `viewmodels/*_viewmodel.dart` + `*_state.dart` |
| **Service** | API calls, token storage | `services/auth_service.dart` |
| **Models** | Request/response data classes | `models/*.dart` |
| **Core** | Network, utils, constants | `core/**/*.dart` |

---

## File Structure

```
lib/
├── core/
│   ├── constants/app_endpoints.dart    ← UPDATE: your base URL
│   ├── network/
│   │   ├── api_client.dart             ← USE AS-IS
│   │   └── failure.dart                ← USE AS-IS (optional, service throws AuthException)
│   └── utils/
│       ├── country_codes.dart
│       ├── device_helper.dart
│       ├── fcm_helper.dart
│       └── phone_number_helper.dart
└── features/
    └── auth/
        ├── models/                     ← USE AS-IS (or add fields)
        │   ├── user_model.dart
        │   ├── login_request_model.dart
        │   └── ... (13 models)
        ├── services/
        │   └── auth_service.dart       ← USE AS-IS
        ├── viewmodels/                 ← USE AS-IS
        │   ├── login_viewmodel.dart
        │   ├── login_state.dart
        │   ├── register_viewmodel.dart
        │   └── ... (8 viewmodels)
        └── presentation/
            └── views/                  ← REPLACE: your custom UI
                ├── login_screen.dart
                ├── register_screen.dart
                ├── forgot_password_screen.dart
                ├── otp_verification_screen.dart
                └── new_password_screen.dart
```

---

## Quick Start

### 1. Copy files to your project

```bash
cp -r lib/core/ your_project/lib/core/
cp -r lib/features/auth/ your_project/lib/features/auth/
```

### 2. Update base URL

```dart
// lib/core/constants/app_endpoints.dart
static const String baseUrl = 'YOUR_API_BASE_URL';
```

### 3. Use in your screen

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_project/core/network/api_client.dart';
import 'package:your_project/features/auth/services/auth_service.dart';
import 'package:your_project/features/auth/viewmodels/login_viewmodel.dart';
import 'package:your_project/features/auth/viewmodels/login_state.dart';

class MyLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(authService: AuthService(apiClient: ApiClient())),
      child: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
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
    );
  }
}
```

---

## ViewModels Reference

| ViewModel | Methods | State |
|-----------|---------|-------|
| `LoginViewModel` | `.login()`, `.loginWithGoogle()`, `.loginWithApple()` | `LoginState` (status, user, errorMessage) |
| `RegisterViewModel` | `.register()` | `RegisterState` (status, errorMessage) |
| `VerifyRegistrationViewModel` | `.verify()` | `VerifyRegistrationState` (status, user, errorMessage) |
| `ForgetPasswordViewModel` | `.forgetPassword()` | `ForgetPasswordState` (status, errorMessage) |
| `VerifyOtpViewModel` | `.verifyOtp()` | `VerifyOtpState` (status, errorMessage) |
| `ResendOtpViewModel` | `.resendOtp()` | `ResendOtpState` (status, errorMessage) |
| `ResetPasswordViewModel` | `.resetPassword()` | `ResetPasswordState` (status, errorMessage) |
| `LogoutViewModel` | `.logout()` | `LogoutState` (status, errorMessage) |

All states use: `{ initial, loading, success, failure }` status enum.

---

## Auth Flow Examples

### Login
```dart
context.read<LoginViewModel>().login(
  login: normalizedPhone,
  password: password,
  locale: 'en',
  fcmToken: token,
  deviceId: id,
  deviceType: 'android',
);
```

### Register → OTP → Verify
```dart
// Step 1: Register
context.read<RegisterViewModel>().register(
  fullName: name, userName: userName, email: email,
  phone: phone, password: pwd, passwordConfirmation: pwd,
  locale: 'en', fcmToken: token, deviceId: id, deviceType: 'ios',
);

// Step 2: Verify OTP (on OTP screen)
context.read<VerifyRegistrationViewModel>().verify(
  login: phone, otp: otp, deviceId: id, deviceType: 'ios',
);
```

### Forgot Password → OTP → Reset
```dart
// Step 1: Send OTP
context.read<ForgetPasswordViewModel>().forgetPassword(login: phone);

// Step 2: Verify OTP
context.read<VerifyOtpViewModel>().verifyOtp(login: phone, otp: otp);

// Step 3: Reset password
context.read<ResetPasswordViewModel>().resetPassword(
  login: phone, otp: otp, password: newPwd, passwordConfirmation: newPwd,
);
```

### Logout
```dart
context.read<LogoutViewModel>().logout(fcmToken: token, deviceId: id);
```

---

## Token Management

- Token auto-saved to `SharedPreferences` on login/verify
- Token auto-injected as `Bearer` header by `AuthInterceptor`
- Token auto-cleared on 401 response
- Check login state:

```dart
final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('auth_token');
final isLoggedIn = token != null && token.isNotEmpty;
```

---

## Dependencies

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

---

## Checklist

- [ ] Copy `lib/core/` and `lib/features/auth/` to your project
- [ ] Update `app_endpoints.dart` with your API base URL
- [ ] Add dependencies to `pubspec.yaml`
- [ ] Build your custom screens using the viewmodels
- [ ] Test: login, register, OTP, forgot password, reset, logout
