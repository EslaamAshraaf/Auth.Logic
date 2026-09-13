# auth_logic

A production-ready authentication package for Flutter apps.

## 1.0.0

- Initial release
- MVVM + Cubit architecture
- Login (phone/email, Google, Apple)
- Register with OTP verification
- Forgot password / reset password flow
- Token management with auto-refresh
- Retry logic (3 attempts with exponential backoff)
- Colored ANSI network logs
- `ApiException` with status codes
- `SecureTokenStorage` abstraction
- `SharedPrefsTokenStorage` default implementation
