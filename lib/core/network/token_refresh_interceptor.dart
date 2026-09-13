import 'package:dio/dio.dart';
import '../storage/secure_token_storage.dart';

/// Interceptor that injects the access token into requests
/// and attempts a token refresh on 401 responses.
class TokenRefreshInterceptor extends Interceptor {
  final SecureTokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  TokenRefreshInterceptor({
    required SecureTokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _tokenStorage.refreshToken;
        if (refreshToken == null) {
          await _tokenStorage.clearTokens();
          _isRefreshing = false;
          return handler.next(err);
        }

        // Attempt refresh — replace with your refresh endpoint
        final response = await _dio.post(
          '/api/auth/refresh',
          data: {'refresh_token': refreshToken},
          options: Options(
            headers: {'Authorization': null}, // no auth header for refresh
          ),
        );

        final data = response.data;
        final newAccessToken =
            (data is Map ? data['access_token'] ?? data['token'] : null)
                as String?;
        final newRefreshToken = data is Map ? data['refresh_token'] as String? : null;

        if (newAccessToken != null) {
          await _tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          // Retry all pending requests with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          for (final pending in _pendingRequests) {
            pending.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
          }
          _pendingRequests.clear();

          // Retry original request
          final response = await _dio.fetch(err.requestOptions);
          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (e) {
        _isRefreshing = false;
        await _tokenStorage.clearTokens();
      }
    }

    _isRefreshing = false;
    return handler.next(err);
  }
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
  _PendingRequest({required this.requestOptions, required this.handler});
}
