// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationModelImpl _$$OrganizationModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizationModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  subdomain: json['subdomain'] as String,
  planType: json['planType'] as String,
  logo: json['logo'] as String?,
  website: json['website'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as Map<String, dynamic>?,
  settings: json['settings'] as Map<String, dynamic>?,
  isActive: json['isActive'] as bool?,
  subscriptionStatus: json['subscriptionStatus'] as String?,
  trialEndsAt: json['trialEndsAt'] == null
      ? null
      : DateTime.parse(json['trialEndsAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$OrganizationModelImplToJson(
  _$OrganizationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'subdomain': instance.subdomain,
  'planType': instance.planType,
  'logo': instance.logo,
  'website': instance.website,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'settings': instance.settings,
  'isActive': instance.isActive,
  'subscriptionStatus': instance.subscriptionStatus,
  'trialEndsAt': instance.trialEndsAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
};
