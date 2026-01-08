import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

/// Organization model matching backend Organization entity
/// Reference: backend/src/modules/organizations/
@freezed
class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    required String id,
    required String name,
    required String subdomain,
    required String planType,
    String? logo,
    String? website,
    String? phone,
    String? email,
    Map<String, dynamic>? address,
    Map<String, dynamic>? settings,
    bool? isActive,
    String? subscriptionStatus,
    DateTime? trialEndsAt,
    DateTime? createdAt,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}

/// Subscription plan types matching backend PlanType enum
enum PlanType {
  @JsonValue('TRIAL')
  trial,
  @JsonValue('BASIC')
  basic,
  @JsonValue('PRO')
  pro,
  @JsonValue('PREMIUM')
  premium,
}

extension PlanTypeExtension on PlanType {
  String get displayName {
    switch (this) {
      case PlanType.trial:
        return 'Trial';
      case PlanType.basic:
        return 'Basic';
      case PlanType.pro:
        return 'Pro';
      case PlanType.premium:
        return 'Premium';
    }
  }

  bool get hasAnalytics => this == PlanType.pro || this == PlanType.premium;
  bool get hasMediaUpload => this == PlanType.pro || this == PlanType.premium;
  bool get hasMultiBranch => this == PlanType.premium;
}
