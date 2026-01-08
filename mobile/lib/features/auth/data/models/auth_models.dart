import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';
import 'organization_model.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// ========================================
// REQUEST DTOs (matching backend exactly)
// ========================================

/// Login request DTO
/// Reference: backend/src/core/auth/dto/login.dto.ts
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Register request DTO
/// Reference: backend/src/core/auth/dto/register.dto.ts
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    // Organization details
    required String organizationName,
    required String subdomain,
    // Admin user details
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Refresh token request
@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

// ========================================
// RESPONSE DTOs
// ========================================

/// Login/Register response
/// Reference: backend/src/core/auth/auth.service.ts (login/register methods)
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required UserModel user,
    required OrganizationModel organization,
    required String accessToken,
    required String refreshToken,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// Refresh token response
@freezed
class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    required String accessToken,
    required String refreshToken,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
