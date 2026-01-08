import '../../../../core/network/dio_client.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

/// Auth API client
/// Reference: backend/src/core/auth/auth.controller.ts
class AuthApiClient {
  final DioClient _dioClient;

  AuthApiClient(this._dioClient);

  /// Login endpoint
  /// POST /auth/login
  /// Reference: backend/src/core/auth/auth.controller.ts line 25-32
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Register endpoint
  /// POST /auth/register
  /// Reference: backend/src/core/auth/auth.controller.ts line 15-22
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.post(
        '/auth/register',
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh token endpoint
  /// POST /auth/refresh
  /// Reference: backend/src/core/auth/auth.controller.ts line 34-42
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      return RefreshTokenResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  /// GET /auth/me
  /// Reference: backend/src/core/auth/auth.controller.ts line 44-51
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get('/auth/me');

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout (client-side only - clear tokens)
  /// Backend doesn't have a logout endpoint (JWT-based auth)
  Future<void> logout() async {
    // Token clearing is handled by the repository
    return;
  }
}
