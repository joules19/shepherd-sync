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

      print('📦 [LOGIN] Raw response: ${response.data}');
      print('👤 [LOGIN] User data: ${response.data['user']}');
      print('🖼️ [LOGIN] Avatar in response: ${response.data['user']?['avatar']}');

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      print('✅ [LOGIN] Parsed user avatar: ${authResponse.user.avatar}');

      return authResponse;
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
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dioClient.get('/auth/me');

      // Backend now returns user with organization nested
      // Extract both user and organization
      final data = response.data as Map<String, dynamic>;

      return {
        'user': data,
        'organization': data['organization'],
      };
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

  /// Update user profile
  /// PATCH /users/:id
  /// Reference: backend/src/modules/users/users.controller.ts line 113-126
  Future<UserModel> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.patch(
        '/users/$userId',
        data: data,
      );

      print('✅ Update profile response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print('❌ Update profile error: $e');
      rethrow;
    }
  }

  /// Validate invite token and get member details
  /// GET /auth/validate-invite?token={token}
  /// Reference: backend/src/core/auth/auth.controller.ts line 54-61
  Future<ValidateInviteResponse> validateInvite(String token) async {
    try {
      final response = await _dioClient.get(
        '/auth/validate-invite',
        queryParameters: {'token': token},
      );

      return ValidateInviteResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Complete member invite and create user account
  /// POST /auth/complete-invite
  /// Reference: backend/src/core/auth/auth.controller.ts line 63-70
  Future<AuthResponse> completeInvite(CompleteInviteRequest request) async {
    try {
      final response = await _dioClient.post(
        '/auth/complete-invite',
        data: request.toJson(),
      );

      print('✅ Complete invite response status: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      try {
        final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
        print('✅ Successfully parsed AuthResponse');
        return authResponse;
      } catch (parseError) {
        print('❌ JSON Parse Error: $parseError');
        print('📊 Response data type: ${response.data.runtimeType}');
        print('📋 Response data keys: ${(response.data as Map).keys}');
        rethrow;
      }
    } catch (e) {
      print('❌ Complete invite error: $e');
      rethrow;
    }
  }
}
