// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.email, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({
    required final String email,
    required final String password,
  }) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  // Organization details
  String get organizationName => throw _privateConstructorUsedError;
  String get subdomain =>
      throw _privateConstructorUsedError; // Admin user details
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
    RegisterRequest value,
    $Res Function(RegisterRequest) then,
  ) = _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call({
    String organizationName,
    String subdomain,
    String firstName,
    String lastName,
    String email,
    String password,
    String? phone,
  });
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationName = null,
    Object? subdomain = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? password = null,
    Object? phone = freezed,
  }) {
    return _then(
      _value.copyWith(
            organizationName: null == organizationName
                ? _value.organizationName
                : organizationName // ignore: cast_nullable_to_non_nullable
                      as String,
            subdomain: null == subdomain
                ? _value.subdomain
                : subdomain // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(
    _$RegisterRequestImpl value,
    $Res Function(_$RegisterRequestImpl) then,
  ) = __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String organizationName,
    String subdomain,
    String firstName,
    String lastName,
    String email,
    String password,
    String? phone,
  });
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
    _$RegisterRequestImpl _value,
    $Res Function(_$RegisterRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationName = null,
    Object? subdomain = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? password = null,
    Object? phone = freezed,
  }) {
    return _then(
      _$RegisterRequestImpl(
        organizationName: null == organizationName
            ? _value.organizationName
            : organizationName // ignore: cast_nullable_to_non_nullable
                  as String,
        subdomain: null == subdomain
            ? _value.subdomain
            : subdomain // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl({
    required this.organizationName,
    required this.subdomain,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
  });

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  // Organization details
  @override
  final String organizationName;
  @override
  final String subdomain;
  // Admin user details
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String password;
  @override
  final String? phone;

  @override
  String toString() {
    return 'RegisterRequest(organizationName: $organizationName, subdomain: $subdomain, firstName: $firstName, lastName: $lastName, email: $email, password: $password, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.subdomain, subdomain) ||
                other.subdomain == subdomain) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    organizationName,
    subdomain,
    firstName,
    lastName,
    email,
    password,
    phone,
  );

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(this);
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest({
    required final String organizationName,
    required final String subdomain,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String password,
    final String? phone,
  }) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  // Organization details
  @override
  String get organizationName;
  @override
  String get subdomain; // Admin user details
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get password;
  @override
  String? get phone;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) {
  return _RefreshTokenRequest.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenRequest {
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshTokenRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshTokenRequestCopyWith<RefreshTokenRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenRequestCopyWith<$Res> {
  factory $RefreshTokenRequestCopyWith(
    RefreshTokenRequest value,
    $Res Function(RefreshTokenRequest) then,
  ) = _$RefreshTokenRequestCopyWithImpl<$Res, RefreshTokenRequest>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class _$RefreshTokenRequestCopyWithImpl<$Res, $Val extends RefreshTokenRequest>
    implements $RefreshTokenRequestCopyWith<$Res> {
  _$RefreshTokenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _value.copyWith(
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefreshTokenRequestImplCopyWith<$Res>
    implements $RefreshTokenRequestCopyWith<$Res> {
  factory _$$RefreshTokenRequestImplCopyWith(
    _$RefreshTokenRequestImpl value,
    $Res Function(_$RefreshTokenRequestImpl) then,
  ) = __$$RefreshTokenRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshTokenRequestImplCopyWithImpl<$Res>
    extends _$RefreshTokenRequestCopyWithImpl<$Res, _$RefreshTokenRequestImpl>
    implements _$$RefreshTokenRequestImplCopyWith<$Res> {
  __$$RefreshTokenRequestImplCopyWithImpl(
    _$RefreshTokenRequestImpl _value,
    $Res Function(_$RefreshTokenRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$RefreshTokenRequestImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenRequestImpl implements _RefreshTokenRequest {
  const _$RefreshTokenRequestImpl({required this.refreshToken});

  factory _$RefreshTokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenRequestImplFromJson(json);

  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshTokenRequest(refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      __$$RefreshTokenRequestImplCopyWithImpl<_$RefreshTokenRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenRequestImplToJson(this);
  }
}

abstract class _RefreshTokenRequest implements RefreshTokenRequest {
  const factory _RefreshTokenRequest({required final String refreshToken}) =
      _$RefreshTokenRequestImpl;

  factory _RefreshTokenRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenRequestImpl.fromJson;

  @override
  String get refreshToken;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  UserModel get user => throw _privateConstructorUsedError;
  OrganizationModel get organization => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  MemberInfo? get member => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
    AuthResponse value,
    $Res Function(AuthResponse) then,
  ) = _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call({
    UserModel user,
    OrganizationModel organization,
    String accessToken,
    String refreshToken,
    MemberInfo? member,
  });

  $UserModelCopyWith<$Res> get user;
  $OrganizationModelCopyWith<$Res> get organization;
  $MemberInfoCopyWith<$Res>? get member;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? organization = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? member = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel,
            organization: null == organization
                ? _value.organization
                : organization // ignore: cast_nullable_to_non_nullable
                      as OrganizationModel,
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            member: freezed == member
                ? _value.member
                : member // ignore: cast_nullable_to_non_nullable
                      as MemberInfo?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrganizationModelCopyWith<$Res> get organization {
    return $OrganizationModelCopyWith<$Res>(_value.organization, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberInfoCopyWith<$Res>? get member {
    if (_value.member == null) {
      return null;
    }

    return $MemberInfoCopyWith<$Res>(_value.member!, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
    _$AuthResponseImpl value,
    $Res Function(_$AuthResponseImpl) then,
  ) = __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UserModel user,
    OrganizationModel organization,
    String accessToken,
    String refreshToken,
    MemberInfo? member,
  });

  @override
  $UserModelCopyWith<$Res> get user;
  @override
  $OrganizationModelCopyWith<$Res> get organization;
  @override
  $MemberInfoCopyWith<$Res>? get member;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
    _$AuthResponseImpl _value,
    $Res Function(_$AuthResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? organization = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? member = freezed,
  }) {
    return _then(
      _$AuthResponseImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        organization: null == organization
            ? _value.organization
            : organization // ignore: cast_nullable_to_non_nullable
                  as OrganizationModel,
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        member: freezed == member
            ? _value.member
            : member // ignore: cast_nullable_to_non_nullable
                  as MemberInfo?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl({
    required this.user,
    required this.organization,
    required this.accessToken,
    required this.refreshToken,
    this.member,
  });

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final UserModel user;
  @override
  final OrganizationModel organization;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final MemberInfo? member;

  @override
  String toString() {
    return 'AuthResponse(user: $user, organization: $organization, accessToken: $accessToken, refreshToken: $refreshToken, member: $member)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.member, member) || other.member == member));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    organization,
    accessToken,
    refreshToken,
    member,
  );

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(this);
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse({
    required final UserModel user,
    required final OrganizationModel organization,
    required final String accessToken,
    required final String refreshToken,
    final MemberInfo? member,
  }) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  UserModel get user;
  @override
  OrganizationModel get organization;
  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  MemberInfo? get member;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) {
  return _MemberInfo.fromJson(json);
}

/// @nodoc
mixin _$MemberInfo {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;

  /// Serializes this MemberInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberInfoCopyWith<MemberInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberInfoCopyWith<$Res> {
  factory $MemberInfoCopyWith(
    MemberInfo value,
    $Res Function(MemberInfo) then,
  ) = _$MemberInfoCopyWithImpl<$Res, MemberInfo>;
  @useResult
  $Res call({String id, String firstName, String lastName});
}

/// @nodoc
class _$MemberInfoCopyWithImpl<$Res, $Val extends MemberInfo>
    implements $MemberInfoCopyWith<$Res> {
  _$MemberInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberInfoImplCopyWith<$Res>
    implements $MemberInfoCopyWith<$Res> {
  factory _$$MemberInfoImplCopyWith(
    _$MemberInfoImpl value,
    $Res Function(_$MemberInfoImpl) then,
  ) = __$$MemberInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String firstName, String lastName});
}

/// @nodoc
class __$$MemberInfoImplCopyWithImpl<$Res>
    extends _$MemberInfoCopyWithImpl<$Res, _$MemberInfoImpl>
    implements _$$MemberInfoImplCopyWith<$Res> {
  __$$MemberInfoImplCopyWithImpl(
    _$MemberInfoImpl _value,
    $Res Function(_$MemberInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
  }) {
    return _then(
      _$MemberInfoImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberInfoImpl implements _MemberInfo {
  const _$MemberInfoImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory _$MemberInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;

  @override
  String toString() {
    return 'MemberInfo(id: $id, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName);

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberInfoImplCopyWith<_$MemberInfoImpl> get copyWith =>
      __$$MemberInfoImplCopyWithImpl<_$MemberInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberInfoImplToJson(this);
  }
}

abstract class _MemberInfo implements MemberInfo {
  const factory _MemberInfo({
    required final String id,
    required final String firstName,
    required final String lastName,
  }) = _$MemberInfoImpl;

  factory _MemberInfo.fromJson(Map<String, dynamic> json) =
      _$MemberInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberInfoImplCopyWith<_$MemberInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshTokenResponse _$RefreshTokenResponseFromJson(Map<String, dynamic> json) {
  return _RefreshTokenResponse.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this RefreshTokenResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshTokenResponseCopyWith<RefreshTokenResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenResponseCopyWith<$Res> {
  factory $RefreshTokenResponseCopyWith(
    RefreshTokenResponse value,
    $Res Function(RefreshTokenResponse) then,
  ) = _$RefreshTokenResponseCopyWithImpl<$Res, RefreshTokenResponse>;
  @useResult
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class _$RefreshTokenResponseCopyWithImpl<
  $Res,
  $Val extends RefreshTokenResponse
>
    implements $RefreshTokenResponseCopyWith<$Res> {
  _$RefreshTokenResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accessToken = null, Object? refreshToken = null}) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefreshTokenResponseImplCopyWith<$Res>
    implements $RefreshTokenResponseCopyWith<$Res> {
  factory _$$RefreshTokenResponseImplCopyWith(
    _$RefreshTokenResponseImpl value,
    $Res Function(_$RefreshTokenResponseImpl) then,
  ) = __$$RefreshTokenResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken, String refreshToken});
}

/// @nodoc
class __$$RefreshTokenResponseImplCopyWithImpl<$Res>
    extends _$RefreshTokenResponseCopyWithImpl<$Res, _$RefreshTokenResponseImpl>
    implements _$$RefreshTokenResponseImplCopyWith<$Res> {
  __$$RefreshTokenResponseImplCopyWithImpl(
    _$RefreshTokenResponseImpl _value,
    $Res Function(_$RefreshTokenResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RefreshTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? accessToken = null, Object? refreshToken = null}) {
    return _then(
      _$RefreshTokenResponseImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenResponseImpl implements _RefreshTokenResponse {
  const _$RefreshTokenResponseImpl({
    required this.accessToken,
    required this.refreshToken,
  });

  factory _$RefreshTokenResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;

  @override
  String toString() {
    return 'RefreshTokenResponse(accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken);

  /// Create a copy of RefreshTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenResponseImplCopyWith<_$RefreshTokenResponseImpl>
  get copyWith =>
      __$$RefreshTokenResponseImplCopyWithImpl<_$RefreshTokenResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenResponseImplToJson(this);
  }
}

abstract class _RefreshTokenResponse implements RefreshTokenResponse {
  const factory _RefreshTokenResponse({
    required final String accessToken,
    required final String refreshToken,
  }) = _$RefreshTokenResponseImpl;

  factory _RefreshTokenResponse.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;

  /// Create a copy of RefreshTokenResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenResponseImplCopyWith<_$RefreshTokenResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ValidateInviteResponse _$ValidateInviteResponseFromJson(
  Map<String, dynamic> json,
) {
  return _ValidateInviteResponse.fromJson(json);
}

/// @nodoc
mixin _$ValidateInviteResponse {
  bool get valid => throw _privateConstructorUsedError;
  InviteMemberData get member => throw _privateConstructorUsedError;
  String get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this ValidateInviteResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidateInviteResponseCopyWith<ValidateInviteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidateInviteResponseCopyWith<$Res> {
  factory $ValidateInviteResponseCopyWith(
    ValidateInviteResponse value,
    $Res Function(ValidateInviteResponse) then,
  ) = _$ValidateInviteResponseCopyWithImpl<$Res, ValidateInviteResponse>;
  @useResult
  $Res call({bool valid, InviteMemberData member, String expiresAt});

  $InviteMemberDataCopyWith<$Res> get member;
}

/// @nodoc
class _$ValidateInviteResponseCopyWithImpl<
  $Res,
  $Val extends ValidateInviteResponse
>
    implements $ValidateInviteResponseCopyWith<$Res> {
  _$ValidateInviteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valid = null,
    Object? member = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            valid: null == valid
                ? _value.valid
                : valid // ignore: cast_nullable_to_non_nullable
                      as bool,
            member: null == member
                ? _value.member
                : member // ignore: cast_nullable_to_non_nullable
                      as InviteMemberData,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InviteMemberDataCopyWith<$Res> get member {
    return $InviteMemberDataCopyWith<$Res>(_value.member, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ValidateInviteResponseImplCopyWith<$Res>
    implements $ValidateInviteResponseCopyWith<$Res> {
  factory _$$ValidateInviteResponseImplCopyWith(
    _$ValidateInviteResponseImpl value,
    $Res Function(_$ValidateInviteResponseImpl) then,
  ) = __$$ValidateInviteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool valid, InviteMemberData member, String expiresAt});

  @override
  $InviteMemberDataCopyWith<$Res> get member;
}

/// @nodoc
class __$$ValidateInviteResponseImplCopyWithImpl<$Res>
    extends
        _$ValidateInviteResponseCopyWithImpl<$Res, _$ValidateInviteResponseImpl>
    implements _$$ValidateInviteResponseImplCopyWith<$Res> {
  __$$ValidateInviteResponseImplCopyWithImpl(
    _$ValidateInviteResponseImpl _value,
    $Res Function(_$ValidateInviteResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? valid = null,
    Object? member = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$ValidateInviteResponseImpl(
        valid: null == valid
            ? _value.valid
            : valid // ignore: cast_nullable_to_non_nullable
                  as bool,
        member: null == member
            ? _value.member
            : member // ignore: cast_nullable_to_non_nullable
                  as InviteMemberData,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidateInviteResponseImpl implements _ValidateInviteResponse {
  const _$ValidateInviteResponseImpl({
    required this.valid,
    required this.member,
    required this.expiresAt,
  });

  factory _$ValidateInviteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidateInviteResponseImplFromJson(json);

  @override
  final bool valid;
  @override
  final InviteMemberData member;
  @override
  final String expiresAt;

  @override
  String toString() {
    return 'ValidateInviteResponse(valid: $valid, member: $member, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidateInviteResponseImpl &&
            (identical(other.valid, valid) || other.valid == valid) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, valid, member, expiresAt);

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidateInviteResponseImplCopyWith<_$ValidateInviteResponseImpl>
  get copyWith =>
      __$$ValidateInviteResponseImplCopyWithImpl<_$ValidateInviteResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidateInviteResponseImplToJson(this);
  }
}

abstract class _ValidateInviteResponse implements ValidateInviteResponse {
  const factory _ValidateInviteResponse({
    required final bool valid,
    required final InviteMemberData member,
    required final String expiresAt,
  }) = _$ValidateInviteResponseImpl;

  factory _ValidateInviteResponse.fromJson(Map<String, dynamic> json) =
      _$ValidateInviteResponseImpl.fromJson;

  @override
  bool get valid;
  @override
  InviteMemberData get member;
  @override
  String get expiresAt;

  /// Create a copy of ValidateInviteResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidateInviteResponseImplCopyWith<_$ValidateInviteResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InviteMemberData _$InviteMemberDataFromJson(Map<String, dynamic> json) {
  return _InviteMemberData.fromJson(json);
}

/// @nodoc
mixin _$InviteMemberData {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get phoneCountryCode => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  String get organizationName => throw _privateConstructorUsedError;
  String? get organizationLogo => throw _privateConstructorUsedError;

  /// Serializes this InviteMemberData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteMemberData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteMemberDataCopyWith<InviteMemberData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteMemberDataCopyWith<$Res> {
  factory $InviteMemberDataCopyWith(
    InviteMemberData value,
    $Res Function(InviteMemberData) then,
  ) = _$InviteMemberDataCopyWithImpl<$Res, InviteMemberData>;
  @useResult
  $Res call({
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String? phoneCountryCode,
    String? photo,
    String organizationName,
    String? organizationLogo,
  });
}

/// @nodoc
class _$InviteMemberDataCopyWithImpl<$Res, $Val extends InviteMemberData>
    implements $InviteMemberDataCopyWith<$Res> {
  _$InviteMemberDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteMemberData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? phoneCountryCode = freezed,
    Object? photo = freezed,
    Object? organizationName = null,
    Object? organizationLogo = freezed,
  }) {
    return _then(
      _value.copyWith(
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneCountryCode: freezed == phoneCountryCode
                ? _value.phoneCountryCode
                : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            photo: freezed == photo
                ? _value.photo
                : photo // ignore: cast_nullable_to_non_nullable
                      as String?,
            organizationName: null == organizationName
                ? _value.organizationName
                : organizationName // ignore: cast_nullable_to_non_nullable
                      as String,
            organizationLogo: freezed == organizationLogo
                ? _value.organizationLogo
                : organizationLogo // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InviteMemberDataImplCopyWith<$Res>
    implements $InviteMemberDataCopyWith<$Res> {
  factory _$$InviteMemberDataImplCopyWith(
    _$InviteMemberDataImpl value,
    $Res Function(_$InviteMemberDataImpl) then,
  ) = __$$InviteMemberDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String firstName,
    String lastName,
    String? email,
    String? phone,
    String? phoneCountryCode,
    String? photo,
    String organizationName,
    String? organizationLogo,
  });
}

/// @nodoc
class __$$InviteMemberDataImplCopyWithImpl<$Res>
    extends _$InviteMemberDataCopyWithImpl<$Res, _$InviteMemberDataImpl>
    implements _$$InviteMemberDataImplCopyWith<$Res> {
  __$$InviteMemberDataImplCopyWithImpl(
    _$InviteMemberDataImpl _value,
    $Res Function(_$InviteMemberDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InviteMemberData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? phoneCountryCode = freezed,
    Object? photo = freezed,
    Object? organizationName = null,
    Object? organizationLogo = freezed,
  }) {
    return _then(
      _$InviteMemberDataImpl(
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneCountryCode: freezed == phoneCountryCode
            ? _value.phoneCountryCode
            : phoneCountryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        photo: freezed == photo
            ? _value.photo
            : photo // ignore: cast_nullable_to_non_nullable
                  as String?,
        organizationName: null == organizationName
            ? _value.organizationName
            : organizationName // ignore: cast_nullable_to_non_nullable
                  as String,
        organizationLogo: freezed == organizationLogo
            ? _value.organizationLogo
            : organizationLogo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteMemberDataImpl implements _InviteMemberData {
  const _$InviteMemberDataImpl({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.phoneCountryCode,
    this.photo,
    required this.organizationName,
    this.organizationLogo,
  });

  factory _$InviteMemberDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteMemberDataImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? phoneCountryCode;
  @override
  final String? photo;
  @override
  final String organizationName;
  @override
  final String? organizationLogo;

  @override
  String toString() {
    return 'InviteMemberData(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, phoneCountryCode: $phoneCountryCode, photo: $photo, organizationName: $organizationName, organizationLogo: $organizationLogo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteMemberDataImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCountryCode, phoneCountryCode) ||
                other.phoneCountryCode == phoneCountryCode) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.organizationLogo, organizationLogo) ||
                other.organizationLogo == organizationLogo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    firstName,
    lastName,
    email,
    phone,
    phoneCountryCode,
    photo,
    organizationName,
    organizationLogo,
  );

  /// Create a copy of InviteMemberData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteMemberDataImplCopyWith<_$InviteMemberDataImpl> get copyWith =>
      __$$InviteMemberDataImplCopyWithImpl<_$InviteMemberDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteMemberDataImplToJson(this);
  }
}

abstract class _InviteMemberData implements InviteMemberData {
  const factory _InviteMemberData({
    required final String firstName,
    required final String lastName,
    final String? email,
    final String? phone,
    final String? phoneCountryCode,
    final String? photo,
    required final String organizationName,
    final String? organizationLogo,
  }) = _$InviteMemberDataImpl;

  factory _InviteMemberData.fromJson(Map<String, dynamic> json) =
      _$InviteMemberDataImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get phoneCountryCode;
  @override
  String? get photo;
  @override
  String get organizationName;
  @override
  String? get organizationLogo;

  /// Create a copy of InviteMemberData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteMemberDataImplCopyWith<_$InviteMemberDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompleteInviteRequest _$CompleteInviteRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CompleteInviteRequest.fromJson(json);
}

/// @nodoc
mixin _$CompleteInviteRequest {
  String get token => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get googleIdToken => throw _privateConstructorUsedError;
  String? get appleAuthCode => throw _privateConstructorUsedError;
  String? get profilePhotoBase64 => throw _privateConstructorUsedError;

  /// Serializes this CompleteInviteRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteInviteRequestCopyWith<CompleteInviteRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteInviteRequestCopyWith<$Res> {
  factory $CompleteInviteRequestCopyWith(
    CompleteInviteRequest value,
    $Res Function(CompleteInviteRequest) then,
  ) = _$CompleteInviteRequestCopyWithImpl<$Res, CompleteInviteRequest>;
  @useResult
  $Res call({
    String token,
    String? password,
    String? googleIdToken,
    String? appleAuthCode,
    String? profilePhotoBase64,
  });
}

/// @nodoc
class _$CompleteInviteRequestCopyWithImpl<
  $Res,
  $Val extends CompleteInviteRequest
>
    implements $CompleteInviteRequestCopyWith<$Res> {
  _$CompleteInviteRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? password = freezed,
    Object? googleIdToken = freezed,
    Object? appleAuthCode = freezed,
    Object? profilePhotoBase64 = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            password: freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String?,
            googleIdToken: freezed == googleIdToken
                ? _value.googleIdToken
                : googleIdToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            appleAuthCode: freezed == appleAuthCode
                ? _value.appleAuthCode
                : appleAuthCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePhotoBase64: freezed == profilePhotoBase64
                ? _value.profilePhotoBase64
                : profilePhotoBase64 // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompleteInviteRequestImplCopyWith<$Res>
    implements $CompleteInviteRequestCopyWith<$Res> {
  factory _$$CompleteInviteRequestImplCopyWith(
    _$CompleteInviteRequestImpl value,
    $Res Function(_$CompleteInviteRequestImpl) then,
  ) = __$$CompleteInviteRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String? password,
    String? googleIdToken,
    String? appleAuthCode,
    String? profilePhotoBase64,
  });
}

/// @nodoc
class __$$CompleteInviteRequestImplCopyWithImpl<$Res>
    extends
        _$CompleteInviteRequestCopyWithImpl<$Res, _$CompleteInviteRequestImpl>
    implements _$$CompleteInviteRequestImplCopyWith<$Res> {
  __$$CompleteInviteRequestImplCopyWithImpl(
    _$CompleteInviteRequestImpl _value,
    $Res Function(_$CompleteInviteRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompleteInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? password = freezed,
    Object? googleIdToken = freezed,
    Object? appleAuthCode = freezed,
    Object? profilePhotoBase64 = freezed,
  }) {
    return _then(
      _$CompleteInviteRequestImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        password: freezed == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String?,
        googleIdToken: freezed == googleIdToken
            ? _value.googleIdToken
            : googleIdToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        appleAuthCode: freezed == appleAuthCode
            ? _value.appleAuthCode
            : appleAuthCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePhotoBase64: freezed == profilePhotoBase64
            ? _value.profilePhotoBase64
            : profilePhotoBase64 // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompleteInviteRequestImpl implements _CompleteInviteRequest {
  const _$CompleteInviteRequestImpl({
    required this.token,
    this.password,
    this.googleIdToken,
    this.appleAuthCode,
    this.profilePhotoBase64,
  });

  factory _$CompleteInviteRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompleteInviteRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String? password;
  @override
  final String? googleIdToken;
  @override
  final String? appleAuthCode;
  @override
  final String? profilePhotoBase64;

  @override
  String toString() {
    return 'CompleteInviteRequest(token: $token, password: $password, googleIdToken: $googleIdToken, appleAuthCode: $appleAuthCode, profilePhotoBase64: $profilePhotoBase64)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteInviteRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.googleIdToken, googleIdToken) ||
                other.googleIdToken == googleIdToken) &&
            (identical(other.appleAuthCode, appleAuthCode) ||
                other.appleAuthCode == appleAuthCode) &&
            (identical(other.profilePhotoBase64, profilePhotoBase64) ||
                other.profilePhotoBase64 == profilePhotoBase64));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    password,
    googleIdToken,
    appleAuthCode,
    profilePhotoBase64,
  );

  /// Create a copy of CompleteInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteInviteRequestImplCopyWith<_$CompleteInviteRequestImpl>
  get copyWith =>
      __$$CompleteInviteRequestImplCopyWithImpl<_$CompleteInviteRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteInviteRequestImplToJson(this);
  }
}

abstract class _CompleteInviteRequest implements CompleteInviteRequest {
  const factory _CompleteInviteRequest({
    required final String token,
    final String? password,
    final String? googleIdToken,
    final String? appleAuthCode,
    final String? profilePhotoBase64,
  }) = _$CompleteInviteRequestImpl;

  factory _CompleteInviteRequest.fromJson(Map<String, dynamic> json) =
      _$CompleteInviteRequestImpl.fromJson;

  @override
  String get token;
  @override
  String? get password;
  @override
  String? get googleIdToken;
  @override
  String? get appleAuthCode;
  @override
  String? get profilePhotoBase64;

  /// Create a copy of CompleteInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteInviteRequestImplCopyWith<_$CompleteInviteRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
