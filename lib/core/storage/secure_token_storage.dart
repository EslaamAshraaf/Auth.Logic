import 'dart:async';

/// Abstract interface for secure token storage.
/// Implement with flutter_secure_storage, hive, or any secure storage.
abstract class SecureTokenStorage {
  Future<String?> get accessToken;
  Future<String?> get refreshToken;
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<void> clearTokens();
}
