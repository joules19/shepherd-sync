// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) {
  return _MemberModel.fromJson(json);
}

/// @nodoc
mixin _$MemberModel {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get organizationId => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneCountryCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get membershipStatus => throw _privateConstructorUsedError;
  String? get joinedDate => throw _privateConstructorUsedError;
  String? get baptismDate => throw _privateConstructorUsedError;
  String? get maritalStatus => throw _privateConstructorUsedError;
  String? get occupation => throw _privateConstructorUsedError;
  AddressModel? get address => throw _privateConstructorUsedError;
  EmergencyContactModel? get emergencyContact =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get customFields => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get inviteStatus => throw _privateConstructorUsedError;
  DateTime? get invitedAt => throw _privateConstructorUsedError;
  DateTime? get activatedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this MemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberModelCopyWith<MemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberModelCopyWith<$Res> {
  factory $MemberModelCopyWith(
    MemberModel value,
    $Res Function(MemberModel) then,
  ) = _$MemberModelCopyWithImpl<$Res, MemberModel>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? organizationId,
    String? email,
    String? phoneCountryCode,
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
    String? inviteStatus,
    DateTime? invitedAt,
    DateTime? activatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });

  $AddressModelCopyWith<$Res>? get address;
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact;
}

/// @nodoc
class _$MemberModelCopyWithImpl<$Res, $Val extends MemberModel>
    implements $MemberModelCopyWith<$Res> {
  _$MemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? organizationId = freezed,
    Object? email = freezed,
    Object? phoneCountryCode = freezed,
    Object? phone = freezed,
    Object? photo = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? membershipStatus = freezed,
    Object? joinedDate = freezed,
    Object? baptismDate = freezed,
    Object? maritalStatus = freezed,
    Object? occupation = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
    Object? customFields = freezed,
    Object? userId = freezed,
    Object? inviteStatus = freezed,
    Object? invitedAt = freezed,
    Object? activatedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            organizationId: freezed == organizationId
                ? _value.organizationId
                : organizationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneCountryCode: freezed == phoneCountryCode
                ? _value.phoneCountryCode
                : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            membershipStatus: freezed == membershipStatus
                ? _value.membershipStatus
                : membershipStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinedDate: freezed == joinedDate
                ? _value.joinedDate
                : joinedDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            baptismDate: freezed == baptismDate
                ? _value.baptismDate
                : baptismDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            maritalStatus: freezed == maritalStatus
                ? _value.maritalStatus
                : maritalStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            occupation: freezed == occupation
                ? _value.occupation
                : occupation // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as AddressModel?,
            emergencyContact: freezed == emergencyContact
                ? _value.emergencyContact
                : emergencyContact // ignore: cast_nullable_to_non_nullable
                      as EmergencyContactModel?,
            customFields: freezed == customFields
                ? _value.customFields
                : customFields // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            inviteStatus: freezed == inviteStatus
                ? _value.inviteStatus
                : inviteStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            invitedAt: freezed == invitedAt
                ? _value.invitedAt
                : invitedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            activatedAt: freezed == activatedAt
                ? _value.activatedAt
                : activatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact {
    if (_value.emergencyContact == null) {
      return null;
    }

    return $EmergencyContactModelCopyWith<$Res>(_value.emergencyContact!, (
      value,
    ) {
      return _then(_value.copyWith(emergencyContact: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MemberModelImplCopyWith<$Res>
    implements $MemberModelCopyWith<$Res> {
  factory _$$MemberModelImplCopyWith(
    _$MemberModelImpl value,
    $Res Function(_$MemberModelImpl) then,
  ) = __$$MemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String? organizationId,
    String? email,
    String? phoneCountryCode,
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
    String? inviteStatus,
    DateTime? invitedAt,
    DateTime? activatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });

  @override
  $AddressModelCopyWith<$Res>? get address;
  @override
  $EmergencyContactModelCopyWith<$Res>? get emergencyContact;
}

/// @nodoc
class __$$MemberModelImplCopyWithImpl<$Res>
    extends _$MemberModelCopyWithImpl<$Res, _$MemberModelImpl>
    implements _$$MemberModelImplCopyWith<$Res> {
  __$$MemberModelImplCopyWithImpl(
    _$MemberModelImpl _value,
    $Res Function(_$MemberModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? organizationId = freezed,
    Object? email = freezed,
    Object? phoneCountryCode = freezed,
    Object? phone = freezed,
    Object? photo = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? membershipStatus = freezed,
    Object? joinedDate = freezed,
    Object? baptismDate = freezed,
    Object? maritalStatus = freezed,
    Object? occupation = freezed,
    Object? address = freezed,
    Object? emergencyContact = freezed,
    Object? customFields = freezed,
    Object? userId = freezed,
    Object? inviteStatus = freezed,
    Object? invitedAt = freezed,
    Object? activatedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$MemberModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationId: freezed == organizationId
            ? _value.organizationId
            : organizationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneCountryCode: freezed == phoneCountryCode
            ? _value.phoneCountryCode
            : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        membershipStatus: freezed == membershipStatus
            ? _value.membershipStatus
            : membershipStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinedDate: freezed == joinedDate
            ? _value.joinedDate
            : joinedDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        baptismDate: freezed == baptismDate
            ? _value.baptismDate
            : baptismDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        maritalStatus: freezed == maritalStatus
            ? _value.maritalStatus
            : maritalStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        occupation: freezed == occupation
            ? _value.occupation
            : occupation // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as AddressModel?,
        emergencyContact: freezed == emergencyContact
            ? _value.emergencyContact
            : emergencyContact // ignore: cast_nullable_to_non_nullable
                  as EmergencyContactModel?,
        customFields: freezed == customFields
            ? _value._customFields
            : customFields // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        inviteStatus: freezed == inviteStatus
            ? _value.inviteStatus
            : inviteStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        invitedAt: freezed == invitedAt
            ? _value.invitedAt
            : invitedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        activatedAt: freezed == activatedAt
            ? _value.activatedAt
            : activatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberModelImpl implements _MemberModel {
  const _$MemberModelImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.organizationId,
    this.email,
    this.phoneCountryCode,
    this.phone,
    this.photo,
    this.dateOfBirth,
    this.gender,
    this.membershipStatus,
    this.joinedDate,
    this.baptismDate,
    this.maritalStatus,
    this.occupation,
    this.address,
    this.emergencyContact,
    final Map<String, dynamic>? customFields,
    this.userId,
    this.inviteStatus,
    this.invitedAt,
    this.activatedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : _customFields = customFields;

  factory _$MemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberModelImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? organizationId;
  @override
  final String? email;
  @override
  final String? phoneCountryCode;
  @override
  final String? phone;
  @override
  final String? photo;
  @override
  final String? dateOfBirth;
  @override
  final String? gender;
  @override
  final String? membershipStatus;
  @override
  final String? joinedDate;
  @override
  final String? baptismDate;
  @override
  final String? maritalStatus;
  @override
  final String? occupation;
  @override
  final AddressModel? address;
  @override
  final EmergencyContactModel? emergencyContact;
  final Map<String, dynamic>? _customFields;
  @override
  Map<String, dynamic>? get customFields {
    final value = _customFields;
    if (value == null) return null;
    if (_customFields is EqualUnmodifiableMapView) return _customFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? userId;
  @override
  final String? inviteStatus;
  @override
  final DateTime? invitedAt;
  @override
  final DateTime? activatedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'MemberModel(id: $id, firstName: $firstName, lastName: $lastName, organizationId: $organizationId, email: $email, phoneCountryCode: $phoneCountryCode, phone: $phone, photo: $photo, dateOfBirth: $dateOfBirth, gender: $gender, membershipStatus: $membershipStatus, joinedDate: $joinedDate, baptismDate: $baptismDate, maritalStatus: $maritalStatus, occupation: $occupation, address: $address, emergencyContact: $emergencyContact, customFields: $customFields, userId: $userId, inviteStatus: $inviteStatus, invitedAt: $invitedAt, activatedAt: $activatedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneCountryCode, phoneCountryCode) ||
                other.phoneCountryCode == phoneCountryCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.membershipStatus, membershipStatus) ||
                other.membershipStatus == membershipStatus) &&
            (identical(other.joinedDate, joinedDate) ||
                other.joinedDate == joinedDate) &&
            (identical(other.baptismDate, baptismDate) ||
                other.baptismDate == baptismDate) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus) &&
            (identical(other.occupation, occupation) ||
                other.occupation == occupation) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            const DeepCollectionEquality().equals(
              other._customFields,
              _customFields,
            ) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.inviteStatus, inviteStatus) ||
                other.inviteStatus == inviteStatus) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    firstName,
    lastName,
    organizationId,
    email,
    phoneCountryCode,
    phone,
    photo,
    dateOfBirth,
    gender,
    membershipStatus,
    joinedDate,
    baptismDate,
    maritalStatus,
    occupation,
    address,
    emergencyContact,
    const DeepCollectionEquality().hash(_customFields),
    userId,
    inviteStatus,
    invitedAt,
    activatedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ]);

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      __$$MemberModelImplCopyWithImpl<_$MemberModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberModelImplToJson(this);
  }
}

abstract class _MemberModel implements MemberModel {
  const factory _MemberModel({
    required final String id,
    required final String firstName,
    required final String lastName,
    final String? organizationId,
    final String? email,
    final String? phoneCountryCode,
    final String? phone,
    final String? photo,
    final String? dateOfBirth,
    final String? gender,
    final String? membershipStatus,
    final String? joinedDate,
    final String? baptismDate,
    final String? maritalStatus,
    final String? occupation,
    final AddressModel? address,
    final EmergencyContactModel? emergencyContact,
    final Map<String, dynamic>? customFields,
    final String? userId,
    final String? inviteStatus,
    final DateTime? invitedAt,
    final DateTime? activatedAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  }) = _$MemberModelImpl;

  factory _MemberModel.fromJson(Map<String, dynamic> json) =
      _$MemberModelImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get organizationId;
  @override
  String? get email;
  @override
  String? get phoneCountryCode;
  @override
  String? get phone;
  @override
  String? get photo;
  @override
  String? get dateOfBirth;
  @override
  String? get gender;
  @override
  String? get membershipStatus;
  @override
  String? get joinedDate;
  @override
  String? get baptismDate;
  @override
  String? get maritalStatus;
  @override
  String? get occupation;
  @override
  AddressModel? get address;
  @override
  EmergencyContactModel? get emergencyContact;
  @override
  Map<String, dynamic>? get customFields;
  @override
  String? get userId;
  @override
  String? get inviteStatus;
  @override
  DateTime? get invitedAt;
  @override
  DateTime? get activatedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of MemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberModelImplCopyWith<_$MemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get zip => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
    AddressModel value,
    $Res Function(AddressModel) then,
  ) = _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call({
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
  });
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zip = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _value.copyWith(
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            zip: freezed == zip
                ? _value.zip
                : zip // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
    _$AddressModelImpl value,
    $Res Function(_$AddressModelImpl) then,
  ) = __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
  });
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
    _$AddressModelImpl _value,
    $Res Function(_$AddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zip = freezed,
    Object? country = freezed,
  }) {
    return _then(
      _$AddressModelImpl(
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        zip: freezed == zip
            ? _value.zip
            : zip // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressModelImpl implements _AddressModel {
  const _$AddressModelImpl({
    this.street,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? zip;
  @override
  final String? country;

  @override
  String toString() {
    return 'AddressModel(street: $street, city: $city, state: $state, zip: $zip, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zip, zip) || other.zip == zip) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, street, city, state, zip, country);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(this);
  }
}

abstract class _AddressModel implements AddressModel {
  const factory _AddressModel({
    final String? street,
    final String? city,
    final String? state,
    final String? zip,
    final String? country,
  }) = _$AddressModelImpl;

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

  @override
  String? get street;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get zip;
  @override
  String? get country;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmergencyContactModel _$EmergencyContactModelFromJson(
  Map<String, dynamic> json,
) {
  return _EmergencyContactModel.fromJson(json);
}

/// @nodoc
mixin _$EmergencyContactModel {
  String? get name => throw _privateConstructorUsedError;
  String? get relationship => throw _privateConstructorUsedError;
  String? get phoneCountryCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this EmergencyContactModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmergencyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmergencyContactModelCopyWith<EmergencyContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmergencyContactModelCopyWith<$Res> {
  factory $EmergencyContactModelCopyWith(
    EmergencyContactModel value,
    $Res Function(EmergencyContactModel) then,
  ) = _$EmergencyContactModelCopyWithImpl<$Res, EmergencyContactModel>;
  @useResult
  $Res call({
    String? name,
    String? relationship,
    String? phoneCountryCode,
    String? phone,
  });
}

/// @nodoc
class _$EmergencyContactModelCopyWithImpl<
  $Res,
  $Val extends EmergencyContactModel
>
    implements $EmergencyContactModelCopyWith<$Res> {
  _$EmergencyContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmergencyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? relationship = freezed,
    Object? phoneCountryCode = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            relationship: freezed == relationship
                ? _value.relationship
                : relationship // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneCountryCode: freezed == phoneCountryCode
                ? _value.phoneCountryCode
                : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmergencyContactModelImplCopyWith<$Res>
    implements $EmergencyContactModelCopyWith<$Res> {
  factory _$$EmergencyContactModelImplCopyWith(
    _$EmergencyContactModelImpl value,
    $Res Function(_$EmergencyContactModelImpl) then,
  ) = __$$EmergencyContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? relationship,
    String? phoneCountryCode,
    String? phone,
  });
}

/// @nodoc
class __$$EmergencyContactModelImplCopyWithImpl<$Res>
    extends
        _$EmergencyContactModelCopyWithImpl<$Res, _$EmergencyContactModelImpl>
    implements _$$EmergencyContactModelImplCopyWith<$Res> {
  __$$EmergencyContactModelImplCopyWithImpl(
    _$EmergencyContactModelImpl _value,
    $Res Function(_$EmergencyContactModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmergencyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? relationship = freezed,
    Object? phoneCountryCode = freezed,
    Object? phone = freezed,
  }) {
    return _then(
      _$EmergencyContactModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        relationship: freezed == relationship
            ? _value.relationship
            : relationship // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneCountryCode: freezed == phoneCountryCode
            ? _value.phoneCountryCode
            : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmergencyContactModelImpl implements _EmergencyContactModel {
  const _$EmergencyContactModelImpl({
    this.name,
    this.relationship,
    this.phoneCountryCode,
    this.phone,
  });

  factory _$EmergencyContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmergencyContactModelImplFromJson(json);

  @override
  final String? name;
  @override
  final String? relationship;
  @override
  final String? phoneCountryCode;
  @override
  final String? phone;

  @override
  String toString() {
    return 'EmergencyContactModel(name: $name, relationship: $relationship, phoneCountryCode: $phoneCountryCode, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmergencyContactModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.phoneCountryCode, phoneCountryCode) ||
                other.phoneCountryCode == phoneCountryCode) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, relationship, phoneCountryCode, phone);

  /// Create a copy of EmergencyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmergencyContactModelImplCopyWith<_$EmergencyContactModelImpl>
  get copyWith =>
      __$$EmergencyContactModelImplCopyWithImpl<_$EmergencyContactModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmergencyContactModelImplToJson(this);
  }
}

abstract class _EmergencyContactModel implements EmergencyContactModel {
  const factory _EmergencyContactModel({
    final String? name,
    final String? relationship,
    final String? phoneCountryCode,
    final String? phone,
  }) = _$EmergencyContactModelImpl;

  factory _EmergencyContactModel.fromJson(Map<String, dynamic> json) =
      _$EmergencyContactModelImpl.fromJson;

  @override
  String? get name;
  @override
  String? get relationship;
  @override
  String? get phoneCountryCode;
  @override
  String? get phone;

  /// Create a copy of EmergencyContactModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmergencyContactModelImplCopyWith<_$EmergencyContactModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PaginatedMembersResponse _$PaginatedMembersResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PaginatedMembersResponse.fromJson(json);
}

/// @nodoc
mixin _$PaginatedMembersResponse {
  List<MemberModel> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this PaginatedMembersResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedMembersResponseCopyWith<PaginatedMembersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedMembersResponseCopyWith<$Res> {
  factory $PaginatedMembersResponseCopyWith(
    PaginatedMembersResponse value,
    $Res Function(PaginatedMembersResponse) then,
  ) = _$PaginatedMembersResponseCopyWithImpl<$Res, PaginatedMembersResponse>;
  @useResult
  $Res call({
    List<MemberModel> data,
    int total,
    int page,
    int limit,
    int totalPages,
  });
}

/// @nodoc
class _$PaginatedMembersResponseCopyWithImpl<
  $Res,
  $Val extends PaginatedMembersResponse
>
    implements $PaginatedMembersResponseCopyWith<$Res> {
  _$PaginatedMembersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<MemberModel>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginatedMembersResponseImplCopyWith<$Res>
    implements $PaginatedMembersResponseCopyWith<$Res> {
  factory _$$PaginatedMembersResponseImplCopyWith(
    _$PaginatedMembersResponseImpl value,
    $Res Function(_$PaginatedMembersResponseImpl) then,
  ) = __$$PaginatedMembersResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MemberModel> data,
    int total,
    int page,
    int limit,
    int totalPages,
  });
}

/// @nodoc
class __$$PaginatedMembersResponseImplCopyWithImpl<$Res>
    extends
        _$PaginatedMembersResponseCopyWithImpl<
          $Res,
          _$PaginatedMembersResponseImpl
        >
    implements _$$PaginatedMembersResponseImplCopyWith<$Res> {
  __$$PaginatedMembersResponseImplCopyWithImpl(
    _$PaginatedMembersResponseImpl _value,
    $Res Function(_$PaginatedMembersResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginatedMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _$PaginatedMembersResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<MemberModel>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedMembersResponseImpl implements _PaginatedMembersResponse {
  const _$PaginatedMembersResponseImpl({
    required final List<MemberModel> data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  }) : _data = data;

  factory _$PaginatedMembersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedMembersResponseImplFromJson(json);

  final List<MemberModel> _data;
  @override
  List<MemberModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PaginatedMembersResponse(data: $data, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedMembersResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    total,
    page,
    limit,
    totalPages,
  );

  /// Create a copy of PaginatedMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedMembersResponseImplCopyWith<_$PaginatedMembersResponseImpl>
  get copyWith =>
      __$$PaginatedMembersResponseImplCopyWithImpl<
        _$PaginatedMembersResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedMembersResponseImplToJson(this);
  }
}

abstract class _PaginatedMembersResponse implements PaginatedMembersResponse {
  const factory _PaginatedMembersResponse({
    required final List<MemberModel> data,
    required final int total,
    required final int page,
    required final int limit,
    required final int totalPages,
  }) = _$PaginatedMembersResponseImpl;

  factory _PaginatedMembersResponse.fromJson(Map<String, dynamic> json) =
      _$PaginatedMembersResponseImpl.fromJson;

  @override
  List<MemberModel> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of PaginatedMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedMembersResponseImplCopyWith<_$PaginatedMembersResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MemberStatsResponse _$MemberStatsResponseFromJson(Map<String, dynamic> json) {
  return _MemberStatsResponse.fromJson(json);
}

/// @nodoc
mixin _$MemberStatsResponse {
  int get totalMembers => throw _privateConstructorUsedError;
  int get activeMembers => throw _privateConstructorUsedError;
  int get visitors => throw _privateConstructorUsedError;
  int get newThisMonth => throw _privateConstructorUsedError;

  /// Serializes this MemberStatsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberStatsResponseCopyWith<MemberStatsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberStatsResponseCopyWith<$Res> {
  factory $MemberStatsResponseCopyWith(
    MemberStatsResponse value,
    $Res Function(MemberStatsResponse) then,
  ) = _$MemberStatsResponseCopyWithImpl<$Res, MemberStatsResponse>;
  @useResult
  $Res call({
    int totalMembers,
    int activeMembers,
    int visitors,
    int newThisMonth,
  });
}

/// @nodoc
class _$MemberStatsResponseCopyWithImpl<$Res, $Val extends MemberStatsResponse>
    implements $MemberStatsResponseCopyWith<$Res> {
  _$MemberStatsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? activeMembers = null,
    Object? visitors = null,
    Object? newThisMonth = null,
  }) {
    return _then(
      _value.copyWith(
            totalMembers: null == totalMembers
                ? _value.totalMembers
                : totalMembers // ignore: cast_nullable_to_non_nullable
                      as int,
            activeMembers: null == activeMembers
                ? _value.activeMembers
                : activeMembers // ignore: cast_nullable_to_non_nullable
                      as int,
            visitors: null == visitors
                ? _value.visitors
                : visitors // ignore: cast_nullable_to_non_nullable
                      as int,
            newThisMonth: null == newThisMonth
                ? _value.newThisMonth
                : newThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberStatsResponseImplCopyWith<$Res>
    implements $MemberStatsResponseCopyWith<$Res> {
  factory _$$MemberStatsResponseImplCopyWith(
    _$MemberStatsResponseImpl value,
    $Res Function(_$MemberStatsResponseImpl) then,
  ) = __$$MemberStatsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalMembers,
    int activeMembers,
    int visitors,
    int newThisMonth,
  });
}

/// @nodoc
class __$$MemberStatsResponseImplCopyWithImpl<$Res>
    extends _$MemberStatsResponseCopyWithImpl<$Res, _$MemberStatsResponseImpl>
    implements _$$MemberStatsResponseImplCopyWith<$Res> {
  __$$MemberStatsResponseImplCopyWithImpl(
    _$MemberStatsResponseImpl _value,
    $Res Function(_$MemberStatsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? activeMembers = null,
    Object? visitors = null,
    Object? newThisMonth = null,
  }) {
    return _then(
      _$MemberStatsResponseImpl(
        totalMembers: null == totalMembers
            ? _value.totalMembers
            : totalMembers // ignore: cast_nullable_to_non_nullable
                  as int,
        activeMembers: null == activeMembers
            ? _value.activeMembers
            : activeMembers // ignore: cast_nullable_to_non_nullable
                  as int,
        visitors: null == visitors
            ? _value.visitors
            : visitors // ignore: cast_nullable_to_non_nullable
                  as int,
        newThisMonth: null == newThisMonth
            ? _value.newThisMonth
            : newThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberStatsResponseImpl implements _MemberStatsResponse {
  const _$MemberStatsResponseImpl({
    required this.totalMembers,
    required this.activeMembers,
    required this.visitors,
    required this.newThisMonth,
  });

  factory _$MemberStatsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberStatsResponseImplFromJson(json);

  @override
  final int totalMembers;
  @override
  final int activeMembers;
  @override
  final int visitors;
  @override
  final int newThisMonth;

  @override
  String toString() {
    return 'MemberStatsResponse(totalMembers: $totalMembers, activeMembers: $activeMembers, visitors: $visitors, newThisMonth: $newThisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberStatsResponseImpl &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.activeMembers, activeMembers) ||
                other.activeMembers == activeMembers) &&
            (identical(other.visitors, visitors) ||
                other.visitors == visitors) &&
            (identical(other.newThisMonth, newThisMonth) ||
                other.newThisMonth == newThisMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalMembers,
    activeMembers,
    visitors,
    newThisMonth,
  );

  /// Create a copy of MemberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberStatsResponseImplCopyWith<_$MemberStatsResponseImpl> get copyWith =>
      __$$MemberStatsResponseImplCopyWithImpl<_$MemberStatsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberStatsResponseImplToJson(this);
  }
}

abstract class _MemberStatsResponse implements MemberStatsResponse {
  const factory _MemberStatsResponse({
    required final int totalMembers,
    required final int activeMembers,
    required final int visitors,
    required final int newThisMonth,
  }) = _$MemberStatsResponseImpl;

  factory _MemberStatsResponse.fromJson(Map<String, dynamic> json) =
      _$MemberStatsResponseImpl.fromJson;

  @override
  int get totalMembers;
  @override
  int get activeMembers;
  @override
  int get visitors;
  @override
  int get newThisMonth;

  /// Create a copy of MemberStatsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberStatsResponseImplCopyWith<_$MemberStatsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SendInviteResponse _$SendInviteResponseFromJson(Map<String, dynamic> json) {
  return _SendInviteResponse.fromJson(json);
}

/// @nodoc
mixin _$SendInviteResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get inviteToken => throw _privateConstructorUsedError;
  String get inviteCode => throw _privateConstructorUsedError;
  String get inviteUrl => throw _privateConstructorUsedError;
  String get expiresAt => throw _privateConstructorUsedError;
  String get sentVia => throw _privateConstructorUsedError;

  /// Serializes this SendInviteResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendInviteResponseCopyWith<SendInviteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendInviteResponseCopyWith<$Res> {
  factory $SendInviteResponseCopyWith(
    SendInviteResponse value,
    $Res Function(SendInviteResponse) then,
  ) = _$SendInviteResponseCopyWithImpl<$Res, SendInviteResponse>;
  @useResult
  $Res call({
    bool success,
    String message,
    String inviteToken,
    String inviteCode,
    String inviteUrl,
    String expiresAt,
    String sentVia,
  });
}

/// @nodoc
class _$SendInviteResponseCopyWithImpl<$Res, $Val extends SendInviteResponse>
    implements $SendInviteResponseCopyWith<$Res> {
  _$SendInviteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? inviteToken = null,
    Object? inviteCode = null,
    Object? inviteUrl = null,
    Object? expiresAt = null,
    Object? sentVia = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            inviteToken: null == inviteToken
                ? _value.inviteToken
                : inviteToken // ignore: cast_nullable_to_non_nullable
                      as String,
            inviteCode: null == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String,
            inviteUrl: null == inviteUrl
                ? _value.inviteUrl
                : inviteUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as String,
            sentVia: null == sentVia
                ? _value.sentVia
                : sentVia // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendInviteResponseImplCopyWith<$Res>
    implements $SendInviteResponseCopyWith<$Res> {
  factory _$$SendInviteResponseImplCopyWith(
    _$SendInviteResponseImpl value,
    $Res Function(_$SendInviteResponseImpl) then,
  ) = __$$SendInviteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String message,
    String inviteToken,
    String inviteCode,
    String inviteUrl,
    String expiresAt,
    String sentVia,
  });
}

/// @nodoc
class __$$SendInviteResponseImplCopyWithImpl<$Res>
    extends _$SendInviteResponseCopyWithImpl<$Res, _$SendInviteResponseImpl>
    implements _$$SendInviteResponseImplCopyWith<$Res> {
  __$$SendInviteResponseImplCopyWithImpl(
    _$SendInviteResponseImpl _value,
    $Res Function(_$SendInviteResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? inviteToken = null,
    Object? inviteCode = null,
    Object? inviteUrl = null,
    Object? expiresAt = null,
    Object? sentVia = null,
  }) {
    return _then(
      _$SendInviteResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        inviteToken: null == inviteToken
            ? _value.inviteToken
            : inviteToken // ignore: cast_nullable_to_non_nullable
                  as String,
        inviteCode: null == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String,
        inviteUrl: null == inviteUrl
            ? _value.inviteUrl
            : inviteUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as String,
        sentVia: null == sentVia
            ? _value.sentVia
            : sentVia // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendInviteResponseImpl implements _SendInviteResponse {
  const _$SendInviteResponseImpl({
    required this.success,
    required this.message,
    required this.inviteToken,
    required this.inviteCode,
    required this.inviteUrl,
    required this.expiresAt,
    required this.sentVia,
  });

  factory _$SendInviteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendInviteResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String inviteToken;
  @override
  final String inviteCode;
  @override
  final String inviteUrl;
  @override
  final String expiresAt;
  @override
  final String sentVia;

  @override
  String toString() {
    return 'SendInviteResponse(success: $success, message: $message, inviteToken: $inviteToken, inviteCode: $inviteCode, inviteUrl: $inviteUrl, expiresAt: $expiresAt, sentVia: $sentVia)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendInviteResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.inviteToken, inviteToken) ||
                other.inviteToken == inviteToken) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.inviteUrl, inviteUrl) ||
                other.inviteUrl == inviteUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.sentVia, sentVia) || other.sentVia == sentVia));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    message,
    inviteToken,
    inviteCode,
    inviteUrl,
    expiresAt,
    sentVia,
  );

  /// Create a copy of SendInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendInviteResponseImplCopyWith<_$SendInviteResponseImpl> get copyWith =>
      __$$SendInviteResponseImplCopyWithImpl<_$SendInviteResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SendInviteResponseImplToJson(this);
  }
}

abstract class _SendInviteResponse implements SendInviteResponse {
  const factory _SendInviteResponse({
    required final bool success,
    required final String message,
    required final String inviteToken,
    required final String inviteCode,
    required final String inviteUrl,
    required final String expiresAt,
    required final String sentVia,
  }) = _$SendInviteResponseImpl;

  factory _SendInviteResponse.fromJson(Map<String, dynamic> json) =
      _$SendInviteResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String get inviteToken;
  @override
  String get inviteCode;
  @override
  String get inviteUrl;
  @override
  String get expiresAt;
  @override
  String get sentVia;

  /// Create a copy of SendInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendInviteResponseImplCopyWith<_$SendInviteResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
