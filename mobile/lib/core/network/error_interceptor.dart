import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/api_exception.dart';

/// Interceptor that handles API errors consistently
/// Converts Dio errors into app-specific exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Convert Dio exception to app-specific exception
    final apiException = _handleError(err);

    // Log error in debug mode
    if (kDebugMode) {
      debugPrint('🔴 API Error: ${apiException.message}');
      debugPrint('   Status: ${apiException.statusCode}');
      debugPrint('   Path: ${err.requestOptions.path}');
    }

    // Pass the error to the next handler
    handler.next(err);
  }

  /// Convert DioException to ApiException
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Request timed out. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: 0,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Certificate verification failed',
          statusCode: 0,
        );

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return ApiException(
            message: 'No internet connection',
            statusCode: 0,
          );
        }
        return ApiException(
          message: 'Something went wrong. Please try again.',
          statusCode: 0,
        );
    }
  }

  /// Handle HTTP response errors (4xx, 5xx)
  ApiException _handleResponseError(Response? response) {
    if (response == null) {
      return ApiException(
        message: 'Unknown error occurred',
        statusCode: 0,
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Try to extract error message from response
    String message;
    try {
      if (data is Map<String, dynamic>) {
        message = data['message'] as String? ??
            data['error'] as String? ??
            _getDefaultErrorMessage(statusCode);
      } else {
        message = _getDefaultErrorMessage(statusCode);
      }
    } catch (_) {
      message = _getDefaultErrorMessage(statusCode);
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      errors: data is Map<String, dynamic> ? data['errors'] as Map<String, dynamic>? : null,
    );
  }

  /// Get default error message based on status code
  String _getDefaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Session expired. Please login again.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'This resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
        return 'Service temporarily unavailable.';
      case 504:
        return 'Gateway timeout. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
