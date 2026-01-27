import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Interceptor that adds JWT token to requests
/// Automatically handles token refresh when needed
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;

  // Track if we're currently refreshing to avoid multiple simultaneous refresh calls
  bool _isRefreshing = false;
  // Queue of pending requests waiting for token refresh
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
      _pendingRequests = [];

  AuthInterceptor(this._secureStorage, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from secure storage
    final accessToken = await _secureStorage.read(
      key: AppConstants.keyAccessToken,
    );

    // Add authorization header if token exists
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Get organization ID and add as header (for multi-tenancy)
    final organizationId = await _secureStorage.read(
      key: AppConstants.keyOrganizationId,
    );

    if (organizationId != null && organizationId.isNotEmpty) {
      options.headers['X-Organization-Id'] = organizationId;
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      final requestOptions = err.requestOptions;

      // Don't retry if it's the refresh endpoint itself (avoid infinite loop)
      if (requestOptions.path.contains('/auth/refresh') ||
          requestOptions.path.contains('/auth/login')) {
        return handler.next(err);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {
        _pendingRequests.add((options: requestOptions, handler: handler));
        return;
      }

      // Mark as refreshing
      _isRefreshing = true;

      try {
        // Get refresh token
        final refreshToken = await _secureStorage.read(
          key: AppConstants.keyRefreshToken,
        );

        if (refreshToken == null || refreshToken.isEmpty) {
          // No refresh token, can't refresh - let error propagate
          _isRefreshing = false;
          return handler.next(err);
        }

        // Call refresh endpoint
        // Note: We create a new Dio instance to avoid interceptor recursion
        final refreshDio = Dio(_dio.options);
        final refreshResponse = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (refreshResponse.statusCode == 200) {
          final newAccessToken = refreshResponse.data['accessToken'] as String;
          final newRefreshToken =
              refreshResponse.data['refreshToken'] as String;

          // Update tokens in secure storage
          await Future.wait([
            _secureStorage.write(
              key: AppConstants.keyAccessToken,
              value: newAccessToken,
            ),
            _secureStorage.write(
              key: AppConstants.keyRefreshToken,
              value: newRefreshToken,
            ),
          ]);

          // Retry the original request with new token
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          // Retry original request
          final response = await _dio.fetch(requestOptions);
          handler.resolve(response);

          // Process all pending requests with new token
          for (final pending in _pendingRequests) {
            pending.options.headers['Authorization'] =
                'Bearer $newAccessToken';
            final pendingResponse = await _dio.fetch(pending.options);
            pending.handler.resolve(pendingResponse);
          }
          _pendingRequests.clear();
        } else {
          // Refresh failed, clear auth data and propagate error
          await _clearAuthData();
          _rejectPendingRequests(err);
          return handler.next(err);
        }
      } catch (e) {
        // Refresh failed, clear auth data and propagate error
        await _clearAuthData();
        _rejectPendingRequests(err);
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      return handler.next(err);
    }
  }

  /// Reject all pending requests when refresh fails
  void _rejectPendingRequests(DioException error) {
    for (final pending in _pendingRequests) {
      pending.handler.next(error);
    }
    _pendingRequests.clear();
  }

  /// Clear all auth data from secure storage
  Future<void> _clearAuthData() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.keyAccessToken),
      _secureStorage.delete(key: AppConstants.keyRefreshToken),
      _secureStorage.delete(key: AppConstants.keyUserId),
      _secureStorage.delete(key: AppConstants.keyOrganizationId),
      _secureStorage.delete(key: AppConstants.keyUserRole),
    ]);
  }
}
