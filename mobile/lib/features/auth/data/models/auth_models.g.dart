// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestImpl(
  organizationName: json['organizationName'] as String,
  subdomain: json['subdomain'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$$RegisterRequestImplToJson(
  _$RegisterRequestImpl instance,
) => <String, dynamic>{
  'organizationName': instance.organizationName,
  'subdomain': instance.subdomain,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
};

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenRequestImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
  _$RefreshTokenRequestImpl instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      organization: OrganizationModel.fromJson(
        json['organization'] as Map<String, dynamic>,
      ),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      member: json['member'] == null
          ? null
          : MemberInfo.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'organization': instance.organization,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'member': instance.member,
    };

_$MemberInfoImpl _$$MemberInfoImplFromJson(Map<String, dynamic> json) =>
    _$MemberInfoImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$$MemberInfoImplToJson(_$MemberInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

_$RefreshTokenResponseImpl _$$RefreshTokenResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenResponseImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$$RefreshTokenResponseImplToJson(
  _$RefreshTokenResponseImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

_$ValidateInviteResponseImpl _$$ValidateInviteResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ValidateInviteResponseImpl(
  valid: json['valid'] as bool,
  member: InviteMemberData.fromJson(json['member'] as Map<String, dynamic>),
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$$ValidateInviteResponseImplToJson(
  _$ValidateInviteResponseImpl instance,
) => <String, dynamic>{
  'valid': instance.valid,
  'member': instance.member,
  'expiresAt': instance.expiresAt,
};

_$InviteMemberDataImpl _$$InviteMemberDataImplFromJson(
  Map<String, dynamic> json,
) => _$InviteMemberDataImpl(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  phoneCountryCode: json['phoneCountryCode'] as String?,
  photo: json['photo'] as String?,
  organizationName: json['organizationName'] as String,
  organizationLogo: json['organizationLogo'] as String?,
);

Map<String, dynamic> _$$InviteMemberDataImplToJson(
  _$InviteMemberDataImpl instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'phoneCountryCode': instance.phoneCountryCode,
  'photo': instance.photo,
  'organizationName': instance.organizationName,
  'organizationLogo': instance.organizationLogo,
};

_$CompleteInviteRequestImpl _$$CompleteInviteRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CompleteInviteRequestImpl(
  token: json['token'] as String,
  password: json['password'] as String?,
  googleIdToken: json['googleIdToken'] as String?,
  appleAuthCode: json['appleAuthCode'] as String?,
  profilePhotoBase64: json['profilePhotoBase64'] as String?,
);

Map<String, dynamic> _$$CompleteInviteRequestImplToJson(
  _$CompleteInviteRequestImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'password': instance.password,
  'googleIdToken': instance.googleIdToken,
  'appleAuthCode': instance.appleAuthCode,
  'profilePhotoBase64': instance.profilePhotoBase64,
};
