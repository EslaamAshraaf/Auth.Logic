import 'dart:convert';
import 'package:dio/dio.dart';
import '../constants/app_endpoints.dart';
import '../storage/secure_token_storage.dart';
import 'token_refresh_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final SecureTokenStorage _tokenStorage;

  ApiClient({
    Dio? dio,
    required SecureTokenStorage tokenStorage,
  })  : _dio = dio ?? Dio(),
        _tokenStorage = tokenStorage {
    _dio.options.baseUrl = AppEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.sendTimeout = const Duration(seconds: 60);
    _dio.options.headers = {'Accept': 'application/json'};

    _dio.interceptors.addAll([
      _RetryOnConnectionErrorInterceptor(),
      TokenRefreshInterceptor(
        tokenStorage: _tokenStorage,
        dio: _dio,
      ),
      _ColorLogInterceptor(),
    ]);
  }

  // ── HTTP Verbs ─────────────────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _resolveOptions(options, data),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _resolveOptions(options, data),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _resolveOptions(options, data),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _resolveOptions(options, data),
    );
  }

  Options? _resolveOptions(Options? options, dynamic data) {
    if (data is FormData) {
      final headers = Map<String, dynamic>.from(options?.headers ?? {});
      headers.remove('Content-Type');
      headers.remove('content-type');
      return (options ?? Options()).copyWith(
        headers: headers,
        contentType: Headers.multipartFormDataContentType,
      );
    }
    return options;
  }
}

// ── Retry Interceptor ────────────────────────────────────────────────────────

class _RetryOnConnectionErrorInterceptor extends Interceptor {
  static const _maxRetries = 3;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;
    if (_isConnectionError(err) && retryCount < _maxRetries) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      _log(
        'RETRY ${retryCount + 1}/$_maxRetries | ${err.requestOptions.method} | ${err.requestOptions.uri}',
        color: _LogColor.yellow,
        icon: '🔁',
      );

      await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));

      try {
        final dio = Dio(BaseOptions(
          baseUrl: err.requestOptions.baseUrl,
          headers: Map<String, dynamic>.from(err.requestOptions.headers),
          connectTimeout: err.requestOptions.connectTimeout,
          receiveTimeout: err.requestOptions.receiveTimeout,
          sendTimeout: err.requestOptions.sendTimeout,
        ));
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  bool _isConnectionError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.message?.contains('Connection closed') == true);
  }
}

// ── Colored Log Interceptor ──────────────────────────────────────────────────

enum _LogColor {
  red,
  green,
  yellow,
  blue,
  cyan,
  magenta,
  white,
  dim,
}

class _ColorLogInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
    options.headers['Pragma'] = 'no-cache';
    options.headers['Expires'] = '0';

    _log(
      'REQUEST | ${options.method} | ${options.uri}',
      color: _LogColor.cyan,
      icon: '🚀',
    );

    if (options.data != null) {
      _prettyPrintJson(options.data, prefix: 'Payload');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    final color = statusCode >= 200 && statusCode < 300
        ? _LogColor.green
        : _LogColor.yellow;

    _log(
      'RESPONSE | ${response.requestOptions.method} | '
      '${response.requestOptions.uri} | $statusCode',
      color: color,
      icon: statusCode >= 200 && statusCode < 300 ? '✅' : '⚠️',
    );

    if (response.data != null) {
      _prettyPrintJson(response.data);
    }

    _log('─' * 60, color: _LogColor.dim, icon: '─');

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode ?? 0;
    final type = err.type.name;

    _log(
      'ERROR | ${err.requestOptions.method} | '
      '${err.requestOptions.uri} | $statusCode ($type)',
      color: _LogColor.red,
      icon: '❌',
    );

    _log(
      'Message: ${err.message ?? "No message"}',
      color: _LogColor.red,
      icon: '💬',
    );

    if (err.error != null) {
      _log(
        'Inner: ${err.error}',
        color: _LogColor.magenta,
        icon: '🔍',
      );
    }

    if (err.response?.data != null) {
      _prettyPrintJson(err.response?.data, prefix: 'Error Body');
    }

    _log('─' * 60, color: _LogColor.dim, icon: '─');

    return handler.next(err);
  }

  // ── Pretty Print ─────────────────────────────────────────────────────────

  void _prettyPrintJson(dynamic rawData, {String prefix = ''}) {
    try {
      if (rawData is Map || rawData is List) {
        const encoder = JsonEncoder.withIndent('  ');
        final formatted = encoder.convert(rawData);
        _log(
          '$prefix:\n$formatted',
          color: _LogColor.dim,
          icon: '📦',
        );
      } else if (rawData is FormData) {
        final buffer = StringBuffer()..writeln('$prefix [FormData]');
        for (final element in rawData.fields) {
          buffer.writeln('  ${element.key}: ${element.value}');
        }
        for (final element in rawData.files) {
          buffer.writeln('  ${element.key}: [File] ${element.value.filename}');
        }
        _log(buffer.toString(), color: _LogColor.dim, icon: '📁');
      } else {
        _log(
          '$prefix: ${rawData.toString()}',
          color: _LogColor.dim,
          icon: '📦',
        );
      }
    } catch (e) {
      _log('$prefix: ${rawData.toString()}', color: _LogColor.dim, icon: '📦');
    }
  }
}

// ── Logger Utility ──────────────────────────────────────────────────────────

void _log(
  String message, {
  required _LogColor color,
  required String icon,
}) {
  final ansi = _ansiCode(color);
  final reset = '\x1B[0m';
  final bold = '\x1B[1m';

  // developer.log strips ANSI, so we use print for colored output
  // ignore: avoid_print
  print('$ansi$bold$icon ${_timestamp()}$reset $ansi$message$reset');
}

String _ansiCode(_LogColor color) {
  switch (color) {
    case _LogColor.red:
      return '\x1B[31m';
    case _LogColor.green:
      return '\x1B[32m';
    case _LogColor.yellow:
      return '\x1B[33m';
    case _LogColor.blue:
      return '\x1B[34m';
    case _LogColor.cyan:
      return '\x1B[36m';
    case _LogColor.magenta:
      return '\x1B[35m';
    case _LogColor.white:
      return '\x1B[37m';
    case _LogColor.dim:
      return '\x1B[2m';
  }
}

String _timestamp() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
}

// ── API Exception ───────────────────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  static ApiException from(Object e) {
    if (e is ApiException) return e;
    if (e is DioException) {
      if (e.error is ApiException) return e.error! as ApiException;
      final statusCode = e.response?.statusCode ?? 0;
      final message = _extractMessage(e.response?.data, statusCode);
      return ApiException(statusCode: statusCode, message: message);
    }
    return ApiException(statusCode: 0, message: e.toString());
  }

  static String _extractMessage(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final buffer = StringBuffer();
        for (final entry in errors.entries) {
          if (entry.value is List) {
            for (final msg in entry.value) {
              if (buffer.isNotEmpty) buffer.writeln();
              buffer.write(msg.toString());
            }
          }
        }
        if (buffer.isNotEmpty) return buffer.toString();
      }
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
      if (data['error'] is String) return data['error'] as String;
    }
    if (statusCode == 422) return 'Invalid data, please check your input.';
    if (statusCode == 401) return 'Unauthorized. Please login again.';
    if (statusCode == 404) return 'Resource not found.';
    return 'Something went wrong. Please try again.';
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isValidationError => statusCode == 422;
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
