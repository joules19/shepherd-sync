// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upcoming_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpcomingEvent _$UpcomingEventFromJson(Map<String, dynamic> json) {
  return _UpcomingEvent.fromJson(json);
}

/// @nodoc
mixin _$UpcomingEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get registeredCount => throw _privateConstructorUsedError;
  int get maxCapacity => throw _privateConstructorUsedError;
  bool get isRegistered => throw _privateConstructorUsedError;

  /// Serializes this UpcomingEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpcomingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpcomingEventCopyWith<UpcomingEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpcomingEventCopyWith<$Res> {
  factory $UpcomingEventCopyWith(
    UpcomingEvent value,
    $Res Function(UpcomingEvent) then,
  ) = _$UpcomingEventCopyWithImpl<$Res, UpcomingEvent>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    String location,
    String? imageUrl,
    int registeredCount,
    int maxCapacity,
    bool isRegistered,
  });
}

/// @nodoc
class _$UpcomingEventCopyWithImpl<$Res, $Val extends UpcomingEvent>
    implements $UpcomingEventCopyWith<$Res> {
  _$UpcomingEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpcomingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? location = null,
    Object? imageUrl = freezed,
    Object? registeredCount = null,
    Object? maxCapacity = null,
    Object? isRegistered = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            registeredCount: null == registeredCount
                ? _value.registeredCount
                : registeredCount // ignore: cast_nullable_to_non_nullable
                      as int,
            maxCapacity: null == maxCapacity
                ? _value.maxCapacity
                : maxCapacity // ignore: cast_nullable_to_non_nullable
                      as int,
            isRegistered: null == isRegistered
                ? _value.isRegistered
                : isRegistered // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpcomingEventImplCopyWith<$Res>
    implements $UpcomingEventCopyWith<$Res> {
  factory _$$UpcomingEventImplCopyWith(
    _$UpcomingEventImpl value,
    $Res Function(_$UpcomingEventImpl) then,
  ) = __$$UpcomingEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    String location,
    String? imageUrl,
    int registeredCount,
    int maxCapacity,
    bool isRegistered,
  });
}

/// @nodoc
class __$$UpcomingEventImplCopyWithImpl<$Res>
    extends _$UpcomingEventCopyWithImpl<$Res, _$UpcomingEventImpl>
    implements _$$UpcomingEventImplCopyWith<$Res> {
  __$$UpcomingEventImplCopyWithImpl(
    _$UpcomingEventImpl _value,
    $Res Function(_$UpcomingEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpcomingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? location = null,
    Object? imageUrl = freezed,
    Object? registeredCount = null,
    Object? maxCapacity = null,
    Object? isRegistered = null,
  }) {
    return _then(
      _$UpcomingEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        registeredCount: null == registeredCount
            ? _value.registeredCount
            : registeredCount // ignore: cast_nullable_to_non_nullable
                  as int,
        maxCapacity: null == maxCapacity
            ? _value.maxCapacity
            : maxCapacity // ignore: cast_nullable_to_non_nullable
                  as int,
        isRegistered: null == isRegistered
            ? _value.isRegistered
            : isRegistered // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpcomingEventImpl implements _UpcomingEvent {
  const _$UpcomingEventImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.imageUrl,
    required this.registeredCount,
    required this.maxCapacity,
    this.isRegistered = false,
  });

  factory _$UpcomingEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpcomingEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String location;
  @override
  final String? imageUrl;
  @override
  final int registeredCount;
  @override
  final int maxCapacity;
  @override
  @JsonKey()
  final bool isRegistered;

  @override
  String toString() {
    return 'UpcomingEvent(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, location: $location, imageUrl: $imageUrl, registeredCount: $registeredCount, maxCapacity: $maxCapacity, isRegistered: $isRegistered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpcomingEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.registeredCount, registeredCount) ||
                other.registeredCount == registeredCount) &&
            (identical(other.maxCapacity, maxCapacity) ||
                other.maxCapacity == maxCapacity) &&
            (identical(other.isRegistered, isRegistered) ||
                other.isRegistered == isRegistered));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    startDate,
    endDate,
    location,
    imageUrl,
    registeredCount,
    maxCapacity,
    isRegistered,
  );

  /// Create a copy of UpcomingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpcomingEventImplCopyWith<_$UpcomingEventImpl> get copyWith =>
      __$$UpcomingEventImplCopyWithImpl<_$UpcomingEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpcomingEventImplToJson(this);
  }
}

abstract class _UpcomingEvent implements UpcomingEvent {
  const factory _UpcomingEvent({
    required final String id,
    required final String title,
    required final String description,
    required final DateTime startDate,
    required final DateTime endDate,
    required final String location,
    final String? imageUrl,
    required final int registeredCount,
    required final int maxCapacity,
    final bool isRegistered,
  }) = _$UpcomingEventImpl;

  factory _UpcomingEvent.fromJson(Map<String, dynamic> json) =
      _$UpcomingEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String get location;
  @override
  String? get imageUrl;
  @override
  int get registeredCount;
  @override
  int get maxCapacity;
  @override
  bool get isRegistered;

  /// Create a copy of UpcomingEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpcomingEventImplCopyWith<_$UpcomingEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
