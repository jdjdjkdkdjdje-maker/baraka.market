import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

// ============================================================
// BARAKA MARKET — Dio HTTP Client (Production Ready)
// ============================================================

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

class DioClient {
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage, _dio),
      _ErrorInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('🌐 DIO: $obj'),
      ),
    ]);
  }

  Dio get instance => _dio;
}

// ─── Auth Interceptor ──────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try token refresh
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken != null) {
        try {
          final response = await _dio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );

          final newAccessToken = response.data['accessToken'] as String;
          final newRefreshToken = response.data['refreshToken'] as String;

          await _storage.write(key: AppConstants.accessTokenKey, value: newAccessToken);
          await _storage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);

          // Retry original request
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.fetch(opts);
          handler.resolve(retryResponse);
          return;
        } catch (e) {
          // Refresh failed → logout
          await _storage.deleteAll();
        }
      }
    }
    handler.next(err);
  }
}

// ─── Error Interceptor ────────────────────────────────────
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiError = _parseError(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: apiError,
        type: err.type,
      ),
    );
  }

  ApiError _parseError(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        code: 'TIMEOUT',
        message: 'Serverga ulanishda xatolik. Qayta urinib ko\'ring.',
      );
    }

    if (err.type == DioExceptionType.connectionError) {
      return ApiError(
        code: 'NO_CONNECTION',
        message: 'Internet aloqasi yo\'q.',
      );
    }

    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiError(
        code: data['code'] ?? 'UNKNOWN',
        message: data['message'] ?? 'Noma\'lum xatolik yuz berdi.',
        statusCode: err.response?.statusCode,
      );
    }

    return ApiError(
      code: 'UNKNOWN',
      message: 'Noma\'lum xatolik yuz berdi.',
      statusCode: err.response?.statusCode,
    );
  }
}

class ApiError {
  final String code;
  final String message;
  final int? statusCode;

  ApiError({
    required this.code,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ApiError($code, $statusCode): $message';
}

void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
