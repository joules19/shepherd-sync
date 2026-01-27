import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

/// Member model matching backend Member entity
/// Reference: backend/src/modules/members/dto/create-member.dto.ts
@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required String id,
    required String firstName,
    required String lastName,
    String? organizationId,
    String? email,
    String? phone,
    String? photo,
    String? dateOfBirth,
    String? gender,
    String? membershipStatus,
    String? joinedDate,
    String? baptismDate,
    String? maritalStatus,
    String? occupation,
    AddressModel? address,
    EmergencyContactModel? emergencyContact,
    Map<String, dynamic>? customFields,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}

/// Address model
@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

/// Emergency contact model
@freezed
class EmergencyContactModel with _$EmergencyContactModel {
  const factory EmergencyContactModel({
    String? name,
    String? relationship,
    String? phone,
  }) = _EmergencyContactModel;

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);
}

/// Gender enum matching backend
enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

/// Membership status enum matching backend
enum MembershipStatus {
  @JsonValue('VISITOR')
  visitor,
  @JsonValue('REGULAR_ATTENDEE')
  regularAttendee,
  @JsonValue('ACTIVE_MEMBER')
  activeMember,
  @JsonValue('INACTIVE')
  inactive,
}

extension MembershipStatusExtension on MembershipStatus {
  String get displayName {
    switch (this) {
      case MembershipStatus.visitor:
        return 'Visitor';
      case MembershipStatus.regularAttendee:
        return 'Regular Attendee';
      case MembershipStatus.activeMember:
        return 'Active Member';
      case MembershipStatus.inactive:
        return 'Inactive';
    }
  }
}

/// Marital status enum matching backend
enum MaritalStatus {
  @JsonValue('SINGLE')
  single,
  @JsonValue('MARRIED')
  married,
  @JsonValue('DIVORCED')
  divorced,
  @JsonValue('WIDOWED')
  widowed,
}

extension MaritalStatusExtension on MaritalStatus {
  String get displayName {
    switch (this) {
      case MaritalStatus.single:
        return 'Single';
      case MaritalStatus.married:
        return 'Married';
      case MaritalStatus.divorced:
        return 'Divorced';
      case MaritalStatus.widowed:
        return 'Widowed';
    }
  }
}

/// Paginated members response
@freezed
class PaginatedMembersResponse with _$PaginatedMembersResponse {
  const factory PaginatedMembersResponse({
    required List<MemberModel> data,
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginatedMembersResponse;

  factory PaginatedMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMembersResponseFromJson(json);
}

/// Member statistics response
@freezed
class MemberStatsResponse with _$MemberStatsResponse {
  const factory MemberStatsResponse({
    required int totalMembers,
    required int activeMembers,
    required int visitors,
    required int newThisMonth,
  }) = _MemberStatsResponse;

  factory MemberStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberStatsResponseFromJson(json);
}
