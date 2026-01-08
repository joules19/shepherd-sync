// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) {
  return _OrganizationModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get subdomain => throw _privateConstructorUsedError;
  String get planType => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  Map<String, dynamic>? get address => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  String? get subscriptionStatus => throw _privateConstructorUsedError;
  DateTime? get trialEndsAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OrganizationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizationModelCopyWith<OrganizationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationModelCopyWith<$Res> {
  factory $OrganizationModelCopyWith(
    OrganizationModel value,
    $Res Function(OrganizationModel) then,
  ) = _$OrganizationModelCopyWithImpl<$Res, OrganizationModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String subdomain,
    String planType,
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
  });
}

/// @nodoc
class _$OrganizationModelCopyWithImpl<$Res, $Val extends OrganizationModel>
    implements $OrganizationModelCopyWith<$Res> {
  _$OrganizationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subdomain = null,
    Object? planType = null,
    Object? logo = freezed,
    Object? website = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? settings = freezed,
    Object? isActive = freezed,
    Object? subscriptionStatus = freezed,
    Object? trialEndsAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            subdomain: null == subdomain
                ? _value.subdomain
                : subdomain // ignore: cast_nullable_to_non_nullable
                      as String,
            planType: null == planType
                ? _value.planType
                : planType // ignore: cast_nullable_to_non_nullable
                      as String,
            logo: freezed == logo
                ? _value.logo
                : logo // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isActive: freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool?,
            subscriptionStatus: freezed == subscriptionStatus
                ? _value.subscriptionStatus
                : subscriptionStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            trialEndsAt: freezed == trialEndsAt
                ? _value.trialEndsAt
                : trialEndsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrganizationModelImplCopyWith<$Res>
    implements $OrganizationModelCopyWith<$Res> {
  factory _$$OrganizationModelImplCopyWith(
    _$OrganizationModelImpl value,
    $Res Function(_$OrganizationModelImpl) then,
  ) = __$$OrganizationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String subdomain,
    String planType,
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
  });
}

/// @nodoc
class __$$OrganizationModelImplCopyWithImpl<$Res>
    extends _$OrganizationModelCopyWithImpl<$Res, _$OrganizationModelImpl>
    implements _$$OrganizationModelImplCopyWith<$Res> {
  __$$OrganizationModelImplCopyWithImpl(
    _$OrganizationModelImpl _value,
    $Res Function(_$OrganizationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? subdomain = null,
    Object? planType = null,
    Object? logo = freezed,
    Object? website = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? settings = freezed,
    Object? isActive = freezed,
    Object? subscriptionStatus = freezed,
    Object? trialEndsAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$OrganizationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        subdomain: null == subdomain
            ? _value.subdomain
            : subdomain // ignore: cast_nullable_to_non_nullable
                  as String,
        planType: null == planType
            ? _value.planType
            : planType // ignore: cast_nullable_to_non_nullable
                  as String,
        logo: freezed == logo
            ? _value.logo
            : logo // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value._address
            : address // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        settings: freezed == settings
            ? _value._settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        subscriptionStatus: freezed == subscriptionStatus
            ? _value.subscriptionStatus
            : subscriptionStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        trialEndsAt: freezed == trialEndsAt
            ? _value.trialEndsAt
            : trialEndsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationModelImpl implements _OrganizationModel {
  const _$OrganizationModelImpl({
    required this.id,
    required this.name,
    required this.subdomain,
    required this.planType,
    this.logo,
    this.website,
    this.phone,
    this.email,
    final Map<String, dynamic>? address,
    final Map<String, dynamic>? settings,
    this.isActive,
    this.subscriptionStatus,
    this.trialEndsAt,
    this.createdAt,
  }) : _address = address,
       _settings = settings;

  factory _$OrganizationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String subdomain;
  @override
  final String planType;
  @override
  final String? logo;
  @override
  final String? website;
  @override
  final String? phone;
  @override
  final String? email;
  final Map<String, dynamic>? _address;
  @override
  Map<String, dynamic>? get address {
    final value = _address;
    if (value == null) return null;
    if (_address is EqualUnmodifiableMapView) return _address;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isActive;
  @override
  final String? subscriptionStatus;
  @override
  final DateTime? trialEndsAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OrganizationModel(id: $id, name: $name, subdomain: $subdomain, planType: $planType, logo: $logo, website: $website, phone: $phone, email: $email, address: $address, settings: $settings, isActive: $isActive, subscriptionStatus: $subscriptionStatus, trialEndsAt: $trialEndsAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subdomain, subdomain) ||
                other.subdomain == subdomain) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(other._address, _address) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.trialEndsAt, trialEndsAt) ||
                other.trialEndsAt == trialEndsAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    subdomain,
    planType,
    logo,
    website,
    phone,
    email,
    const DeepCollectionEquality().hash(_address),
    const DeepCollectionEquality().hash(_settings),
    isActive,
    subscriptionStatus,
    trialEndsAt,
    createdAt,
  );

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      __$$OrganizationModelImplCopyWithImpl<_$OrganizationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationModelImplToJson(this);
  }
}

abstract class _OrganizationModel implements OrganizationModel {
  const factory _OrganizationModel({
    required final String id,
    required final String name,
    required final String subdomain,
    required final String planType,
    final String? logo,
    final String? website,
    final String? phone,
    final String? email,
    final Map<String, dynamic>? address,
    final Map<String, dynamic>? settings,
    final bool? isActive,
    final String? subscriptionStatus,
    final DateTime? trialEndsAt,
    final DateTime? createdAt,
  }) = _$OrganizationModelImpl;

  factory _OrganizationModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get subdomain;
  @override
  String get planType;
  @override
  String? get logo;
  @override
  String? get website;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  Map<String, dynamic>? get address;
  @override
  Map<String, dynamic>? get settings;
  @override
  bool? get isActive;
  @override
  String? get subscriptionStatus;
  @override
  DateTime? get trialEndsAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
