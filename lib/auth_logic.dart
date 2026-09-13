/// A production-ready authentication package for Flutter.
///
/// MVVM architecture with Cubit state management.
/// Supports login, register, forgot password, OTP verification, and more.
///
/// ```dart
/// import 'package:auth_logic/auth_logic.dart';
///
/// final deps = AuthDependencies.create();
/// final authService = deps.authService;
/// ```
library auth_logic;

// ── Core ─────────────────────────────────────────────────────────────────────
export 'src/core/constants/app_endpoints.dart';
export 'src/core/network/api_client.dart';
export 'src/core/network/failure.dart';
export 'src/core/network/token_refresh_interceptor.dart';
export 'src/core/storage/secure_token_storage.dart';
export 'src/core/storage/shared_prefs_token_storage.dart';
export 'src/core/di/auth_dependencies.dart';

// ── Models ───────────────────────────────────────────────────────────────────
export 'src/features/auth/models/user_model.dart';
export 'src/features/auth/models/login_request_model.dart';
export 'src/features/auth/models/google_login_request_model.dart';
export 'src/features/auth/models/apple_login_request_model.dart';
export 'src/features/auth/models/register_request_model.dart';
export 'src/features/auth/models/verify_registration_request_model.dart';
export 'src/features/auth/models/forget_password_request_model.dart';
export 'src/features/auth/models/verify_otp_request_model.dart';
export 'src/features/auth/models/resend_otp_request_model.dart';
export 'src/features/auth/models/reset_password_request_model.dart';
export 'src/features/auth/models/change_password_request_model.dart';
export 'src/features/auth/models/logout_request_model.dart';
export 'src/features/auth/models/update_profile_request_model.dart';

// ── Service ──────────────────────────────────────────────────────────────────
export 'src/features/auth/services/auth_service.dart';

// ── ViewModels ───────────────────────────────────────────────────────────────
export 'src/features/auth/viewmodels/login_viewmodel.dart';
export 'src/features/auth/viewmodels/login_state.dart';
export 'src/features/auth/viewmodels/register_viewmodel.dart';
export 'src/features/auth/viewmodels/register_state.dart';
export 'src/features/auth/viewmodels/verify_registration_viewmodel.dart';
export 'src/features/auth/viewmodels/verify_registration_state.dart';
export 'src/features/auth/viewmodels/forget_password_viewmodel.dart';
export 'src/features/auth/viewmodels/forget_password_state.dart';
export 'src/features/auth/viewmodels/verify_otp_viewmodel.dart';
export 'src/features/auth/viewmodels/verify_otp_state.dart';
export 'src/features/auth/viewmodels/resend_otp_viewmodel.dart';
export 'src/features/auth/viewmodels/resend_otp_state.dart';
export 'src/features/auth/viewmodels/reset_password_viewmodel.dart';
export 'src/features/auth/viewmodels/reset_password_state.dart';
export 'src/features/auth/viewmodels/logout_viewmodel.dart';
export 'src/features/auth/viewmodels/logout_state.dart';

// ── Utils ────────────────────────────────────────────────────────────────────
export 'src/core/utils/phone_number_helper.dart';
export 'src/core/utils/device_helper.dart';
export 'src/core/utils/fcm_helper.dart';
export 'src/core/utils/country_codes.dart';
