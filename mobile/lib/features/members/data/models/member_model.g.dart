// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberModelImpl _$$MemberModelImplFromJson(Map<String, dynamic> json) =>
    _$MemberModelImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      organizationId: json['organizationId'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      membershipStatus: json['membershipStatus'] as String?,
      joinedDate: json['joinedDate'] as String?,
      baptismDate: json['baptismDate'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      occupation: json['occupation'] as String?,
      address: json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      emergencyContact: json['emergencyContact'] == null
          ? null
          : EmergencyContactModel.fromJson(
              json['emergencyContact'] as Map<String, dynamic>,
            ),
      customFields: json['customFields'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$MemberModelImplToJson(_$MemberModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'organizationId': instance.organizationId,
      'email': instance.email,
      'phone': instance.phone,
      'photo': instance.photo,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'membershipStatus': instance.membershipStatus,
      'joinedDate': instance.joinedDate,
      'baptismDate': instance.baptismDate,
      'maritalStatus': instance.maritalStatus,
      'occupation': instance.occupation,
      'address': instance.address,
      'emergencyContact': instance.emergencyContact,
      'customFields': instance.customFields,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'country': instance.country,
    };

_$EmergencyContactModelImpl _$$EmergencyContactModelImplFromJson(
  Map<String, dynamic> json,
) => _$EmergencyContactModelImpl(
  name: json['name'] as String?,
  relationship: json['relationship'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$$EmergencyContactModelImplToJson(
  _$EmergencyContactModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'relationship': instance.relationship,
  'phone': instance.phone,
};

_$PaginatedMembersResponseImpl _$$PaginatedMembersResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedMembersResponseImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$$PaginatedMembersResponseImplToJson(
  _$PaginatedMembersResponseImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};

_$MemberStatsResponseImpl _$$MemberStatsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MemberStatsResponseImpl(
  totalMembers: (json['totalMembers'] as num).toInt(),
  activeMembers: (json['activeMembers'] as num).toInt(),
  visitors: (json['visitors'] as num).toInt(),
  newThisMonth: (json['newThisMonth'] as num).toInt(),
);

Map<String, dynamic> _$$MemberStatsResponseImplToJson(
  _$MemberStatsResponseImpl instance,
) => <String, dynamic>{
  'totalMembers': instance.totalMembers,
  'activeMembers': instance.activeMembers,
  'visitors': instance.visitors,
  'newThisMonth': instance.newThisMonth,
};
