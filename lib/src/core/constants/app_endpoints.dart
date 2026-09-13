abstract class AppEndpoints {
  static const String baseUrl = 'https://api.example.com';
  static const String login = '/api/app/auth/login';
  static const String googleLogin = '/api/app-user/auth/google/token';
  static const String appleLogin = '/api/app-user/auth/apple/token';
  static const String register = '/api/app/auth/register';
  static const String verifyRegistration = '/api/app/auth/verify-registration';
  static const String forgetPassword = '/api/app/auth/forget-password';
  static const String resetPassword = '/api/app/auth/reset-password';
  static const String verifyOtp = '/api/app/auth/verify-otp';
  static const String resendOtp = '/api/app/auth/resend-otp';
  static const String logout = '/api/app/auth/logout';
  static const String getProfile = '/api/app/auth/me';
  static const String updateProfile = '/api/app/auth/update-profile';
  static const String changePassword = '/api/app/auth/change-password';
}
