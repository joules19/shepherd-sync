import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/api_exception.dart';
import '../datasources/auth_api_client.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

/// Auth repository - handles authentication logic and token storage
/// Implements Either pattern for error handling
class AuthRepository {
  final AuthApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(this._apiClient, this._secureStorage);

  // ========================================
  // AUTH OPERATIONS
  // ========================================

  /// Login user
  Future<Either<ApiException, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.login(request);

      // Store tokens and user data securely
      await _saveAuthData(response);

      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Login failed. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Register new organization and admin user
  Future<Either<ApiException, AuthResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _apiClient.register(request);

      // Store tokens and user data securely
      await _saveAuthData(response);

      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Registration failed. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Refresh access token
  Future<Either<ApiException, RefreshTokenResponse>> refreshToken() async {
    try {
      // Get refresh token from storage
      final refreshToken = await _secureStorage.read(
        key: AppConstants.keyRefreshToken,
      );

      if (refreshToken == null) {
        return Left(ApiException(
          message: 'No refresh token found',
          statusCode: 401,
        ));
      }

      final response = await _apiClient.refreshToken(refreshToken);

      // Update tokens
      await _secureStorage.write(
        key: AppConstants.keyAccessToken,
        value: response.accessToken,
      );
      await _secureStorage.write(
        key: AppConstants.keyRefreshToken,
        value: response.refreshToken,
      );

      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Token refresh failed',
        statusCode: 0,
      ));
    }
  }

  /// Get current user profile
  Future<Either<ApiException, UserModel>> getCurrentUser() async {
    try {
      final user = await _apiClient.getCurrentUser();
      return Right(user);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to fetch user profile',
        statusCode: 0,
      ));
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _clearAuthData();
  }

  // ========================================
  // TOKEN MANAGEMENT
  // ========================================

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await _secureStorage.read(
      key: AppConstants.keyAccessToken,
    );
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.keyAccessToken);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.keyRefreshToken);
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: AppConstants.keyUserId);
  }

  /// Get stored organization ID
  Future<String?> getOrganizationId() async {
    return await _secureStorage.read(key: AppConstants.keyOrganizationId);
  }

  // ========================================
  // PRIVATE HELPERS
  // ========================================

  /// Save auth data to secure storage
  Future<void> _saveAuthData(AuthResponse response) async {
    await Future.wait([
      _secureStorage.write(
        key: AppConstants.keyAccessToken,
        value: response.accessToken,
      ),
      _secureStorage.write(
        key: AppConstants.keyRefreshToken,
        value: response.refreshToken,
      ),
      _secureStorage.write(
        key: AppConstants.keyUserId,
        value: response.user.id,
      ),
      _secureStorage.write(
        key: AppConstants.keyOrganizationId,
        value: response.user.organizationId,
      ),
      _secureStorage.write(
        key: AppConstants.keyUserRole,
        value: response.user.role,
      ),
    ]);
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
