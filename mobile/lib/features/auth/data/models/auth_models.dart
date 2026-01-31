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
    MemberInfo? member, // Optional - only returned from completeInvite
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// Member info returned from complete invite
@freezed
class MemberInfo with _$MemberInfo {
  const factory MemberInfo({
    required String id,
    required String firstName,
    required String lastName,
  }) = _MemberInfo;

  factory MemberInfo.fromJson(Map<String, dynamic> json) =>
      _$MemberInfoFromJson(json);
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

// ========================================
// INVITE SYSTEM DTOs
// ========================================

/// Validate invite response
/// Reference: backend/src/core/auth/auth.service.ts validateInvite() return
@freezed
class ValidateInviteResponse with _$ValidateInviteResponse {
  const factory ValidateInviteResponse({
    required bool valid,
    required InviteMemberData member,
    required String expiresAt,
  }) = _ValidateInviteResponse;

  factory ValidateInviteResponse.fromJson(Map<String, dynamic> json) =>
      _$ValidateInviteResponseFromJson(json);
}

/// Member data from invite validation
@freezed
class InviteMemberData with _$InviteMemberData {
  const factory InviteMemberData({
    required String firstName,
    required String lastName,
    String? email,
    String? phone,
    String? phoneCountryCode,
    String? photo,
    required String organizationName,
    String? organizationLogo,
  }) = _InviteMemberData;

  factory InviteMemberData.fromJson(Map<String, dynamic> json) =>
      _$InviteMemberDataFromJson(json);
}

/// Complete invite request
/// Reference: backend/src/modules/members/dto/complete-invite.dto.ts
@freezed
class CompleteInviteRequest with _$CompleteInviteRequest {
  const factory CompleteInviteRequest({
    required String token,
    String? password,
    String? googleIdToken,
    String? appleAuthCode,
    String? profilePhotoBase64,
  }) = _CompleteInviteRequest;

  factory CompleteInviteRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteInviteRequestFromJson(json);
}
