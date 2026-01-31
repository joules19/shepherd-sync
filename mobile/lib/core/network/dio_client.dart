import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import '../errors/api_exception.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

/// Dio HTTP client configured for Shepherd Sync API
/// Includes authentication, logging, and error handling
class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient(this._secureStorage) {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  /// Base options for all requests
  BaseOptions get _baseOptions => BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiConnectTimeout,
        receiveTimeout: AppConstants.apiReceiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          // Consider all status codes < 500 as success
          // We'll handle 400-499 errors in the error interceptor
          return status != null && status < 500;
        },
      );

  /// Setup interceptors for auth, logging, and error handling
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // Auth interceptor - adds JWT token to requests and handles refresh
      AuthInterceptor(_secureStorage, _dio),

      // Pretty logging (only in debug mode)
      if (const bool.fromEnvironment('dart.vm.product') == false)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),

      // Error interceptor - handles API errors consistently
      ErrorInterceptor(),
    ]);
  }

  /// Public Dio instance for making requests
  Dio get instance => _dio;

  // ========================================
  // ERROR HANDLING HELPER
  // ========================================

  /// Handles DioException and extracts ApiException
  /// This is called automatically by all convenience methods
  Never _handleError(Object error) {
    if (error is DioException && error.error is ApiException) {
      // Extract and throw the actual ApiException from ErrorInterceptor
      throw error.error as ApiException;
    }
    // If it's already an ApiException, rethrow it
    if (error is ApiException) {
      throw error;
    }
    // Otherwise rethrow the original error
    throw error;
  }

  // ========================================
  // CONVENIENCE METHODS
  // ========================================

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } catch (e) {
      _handleError(e);
    }
  }
}
