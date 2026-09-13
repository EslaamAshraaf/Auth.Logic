import '../network/api_client.dart';
import '../storage/secure_token_storage.dart';
import '../storage/shared_prefs_token_storage.dart';
import '../../features/auth/services/auth_service.dart';

/// Factory for creating auth dependencies.
/// Call `AuthDependencies.create()` to get pre-configured instances.
class AuthDependencies {
  final ApiClient apiClient;
  final SecureTokenStorage tokenStorage;
  final AuthService authService;

  AuthDependencies._({
    required this.apiClient,
    required this.tokenStorage,
    required this.authService,
  });

  /// Creates all dependencies with SharedPrefsTokenStorage (default).
  static AuthDependencies create() {
    final tokenStorage = SharedPrefsTokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final authService = AuthService(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    );
    return AuthDependencies._(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
      authService: authService,
    );
  }

  /// Creates with a custom SecureTokenStorage implementation.
  static AuthDependencies createWith({required SecureTokenStorage tokenStorage}) {
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final authService = AuthService(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    );
    return AuthDependencies._(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
      authService: authService,
    );
  }
}
