import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model matching backend User entity
/// Reference: backend/src/modules/users/
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    required String organizationId,
    String? phone,
    String? profilePicture,
    @Default(true) bool isActive, // Backend doesn't return in auth response
    bool? emailVerified,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// User roles matching backend UserRole enum
enum UserRole {
  @JsonValue('SUPER_ADMIN')
  superAdmin,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('PASTOR')
  pastor,
  @JsonValue('USHER')
  usher,
  @JsonValue('MEMBER')
  member,
  @JsonValue('PARENT')
  parent,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.pastor:
        return 'Pastor';
      case UserRole.usher:
        return 'Usher';
      case UserRole.member:
        return 'Member';
      case UserRole.parent:
        return 'Parent';
    }
  }

  bool get isAdmin => this == UserRole.admin || this == UserRole.superAdmin;
  bool get canManageEvents => isAdmin || this == UserRole.pastor;
  bool get canCheckIn => isAdmin || this == UserRole.usher;
}
