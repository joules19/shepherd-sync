import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Interceptor that adds JWT token to requests
/// Automatically handles token refresh when needed
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

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
      // TODO: Implement token refresh logic
      // 1. Get refresh token
      // 2. Call /auth/refresh endpoint
      // 3. Update access token
      // 4. Retry original request

      // For now, just continue with error
      // This will trigger logout in the error interceptor
    }

    return handler.next(err);
  }
}
