// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  GivingStats get giving => throw _privateConstructorUsedError;
  AttendanceStats get attendance => throw _privateConstructorUsedError;
  EventStats get events => throw _privateConstructorUsedError;
  MemberStats get members => throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    GivingStats giving,
    AttendanceStats attendance,
    EventStats events,
    MemberStats members,
  });

  $GivingStatsCopyWith<$Res> get giving;
  $AttendanceStatsCopyWith<$Res> get attendance;
  $EventStatsCopyWith<$Res> get events;
  $MemberStatsCopyWith<$Res> get members;
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? giving = null,
    Object? attendance = null,
    Object? events = null,
    Object? members = null,
  }) {
    return _then(
      _value.copyWith(
            giving: null == giving
                ? _value.giving
                : giving // ignore: cast_nullable_to_non_nullable
                      as GivingStats,
            attendance: null == attendance
                ? _value.attendance
                : attendance // ignore: cast_nullable_to_non_nullable
                      as AttendanceStats,
            events: null == events
                ? _value.events
                : events // ignore: cast_nullable_to_non_nullable
                      as EventStats,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as MemberStats,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GivingStatsCopyWith<$Res> get giving {
    return $GivingStatsCopyWith<$Res>(_value.giving, (value) {
      return _then(_value.copyWith(giving: value) as $Val);
    });
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendanceStatsCopyWith<$Res> get attendance {
    return $AttendanceStatsCopyWith<$Res>(_value.attendance, (value) {
      return _then(_value.copyWith(attendance: value) as $Val);
    });
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventStatsCopyWith<$Res> get events {
    return $EventStatsCopyWith<$Res>(_value.events, (value) {
      return _then(_value.copyWith(events: value) as $Val);
    });
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberStatsCopyWith<$Res> get members {
    return $MemberStatsCopyWith<$Res>(_value.members, (value) {
      return _then(_value.copyWith(members: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GivingStats giving,
    AttendanceStats attendance,
    EventStats events,
    MemberStats members,
  });

  @override
  $GivingStatsCopyWith<$Res> get giving;
  @override
  $AttendanceStatsCopyWith<$Res> get attendance;
  @override
  $EventStatsCopyWith<$Res> get events;
  @override
  $MemberStatsCopyWith<$Res> get members;
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? giving = null,
    Object? attendance = null,
    Object? events = null,
    Object? members = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        giving: null == giving
            ? _value.giving
            : giving // ignore: cast_nullable_to_non_nullable
                  as GivingStats,
        attendance: null == attendance
            ? _value.attendance
            : attendance // ignore: cast_nullable_to_non_nullable
                  as AttendanceStats,
        events: null == events
            ? _value.events
            : events // ignore: cast_nullable_to_non_nullable
                  as EventStats,
        members: null == members
            ? _value.members
            : members // ignore: cast_nullable_to_non_nullable
                  as MemberStats,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    required this.giving,
    required this.attendance,
    required this.events,
    required this.members,
  });

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  final GivingStats giving;
  @override
  final AttendanceStats attendance;
  @override
  final EventStats events;
  @override
  final MemberStats members;

  @override
  String toString() {
    return 'DashboardStats(giving: $giving, attendance: $attendance, events: $events, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.giving, giving) || other.giving == giving) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.events, events) || other.events == events) &&
            (identical(other.members, members) || other.members == members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, giving, attendance, events, members);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    required final GivingStats giving,
    required final AttendanceStats attendance,
    required final EventStats events,
    required final MemberStats members,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  GivingStats get giving;
  @override
  AttendanceStats get attendance;
  @override
  EventStats get events;
  @override
  MemberStats get members;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GivingStats _$GivingStatsFromJson(Map<String, dynamic> json) {
  return _GivingStats.fromJson(json);
}

/// @nodoc
mixin _$GivingStats {
  double get totalThisMonth => throw _privateConstructorUsedError;
  double get totalThisYear => throw _privateConstructorUsedError;
  double get totalAllTime => throw _privateConstructorUsedError;
  int get donationsThisMonth => throw _privateConstructorUsedError;
  double get percentageChange => throw _privateConstructorUsedError;

  /// Serializes this GivingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GivingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GivingStatsCopyWith<GivingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GivingStatsCopyWith<$Res> {
  factory $GivingStatsCopyWith(
    GivingStats value,
    $Res Function(GivingStats) then,
  ) = _$GivingStatsCopyWithImpl<$Res, GivingStats>;
  @useResult
  $Res call({
    double totalThisMonth,
    double totalThisYear,
    double totalAllTime,
    int donationsThisMonth,
    double percentageChange,
  });
}

/// @nodoc
class _$GivingStatsCopyWithImpl<$Res, $Val extends GivingStats>
    implements $GivingStatsCopyWith<$Res> {
  _$GivingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GivingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalThisMonth = null,
    Object? totalThisYear = null,
    Object? totalAllTime = null,
    Object? donationsThisMonth = null,
    Object? percentageChange = null,
  }) {
    return _then(
      _value.copyWith(
            totalThisMonth: null == totalThisMonth
                ? _value.totalThisMonth
                : totalThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            totalThisYear: null == totalThisYear
                ? _value.totalThisYear
                : totalThisYear // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAllTime: null == totalAllTime
                ? _value.totalAllTime
                : totalAllTime // ignore: cast_nullable_to_non_nullable
                      as double,
            donationsThisMonth: null == donationsThisMonth
                ? _value.donationsThisMonth
                : donationsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            percentageChange: null == percentageChange
                ? _value.percentageChange
                : percentageChange // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GivingStatsImplCopyWith<$Res>
    implements $GivingStatsCopyWith<$Res> {
  factory _$$GivingStatsImplCopyWith(
    _$GivingStatsImpl value,
    $Res Function(_$GivingStatsImpl) then,
  ) = __$$GivingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalThisMonth,
    double totalThisYear,
    double totalAllTime,
    int donationsThisMonth,
    double percentageChange,
  });
}

/// @nodoc
class __$$GivingStatsImplCopyWithImpl<$Res>
    extends _$GivingStatsCopyWithImpl<$Res, _$GivingStatsImpl>
    implements _$$GivingStatsImplCopyWith<$Res> {
  __$$GivingStatsImplCopyWithImpl(
    _$GivingStatsImpl _value,
    $Res Function(_$GivingStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GivingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalThisMonth = null,
    Object? totalThisYear = null,
    Object? totalAllTime = null,
    Object? donationsThisMonth = null,
    Object? percentageChange = null,
  }) {
    return _then(
      _$GivingStatsImpl(
        totalThisMonth: null == totalThisMonth
            ? _value.totalThisMonth
            : totalThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        totalThisYear: null == totalThisYear
            ? _value.totalThisYear
            : totalThisYear // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAllTime: null == totalAllTime
            ? _value.totalAllTime
            : totalAllTime // ignore: cast_nullable_to_non_nullable
                  as double,
        donationsThisMonth: null == donationsThisMonth
            ? _value.donationsThisMonth
            : donationsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        percentageChange: null == percentageChange
            ? _value.percentageChange
            : percentageChange // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GivingStatsImpl implements _GivingStats {
  const _$GivingStatsImpl({
    required this.totalThisMonth,
    required this.totalThisYear,
    required this.totalAllTime,
    required this.donationsThisMonth,
    required this.percentageChange,
  });

  factory _$GivingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GivingStatsImplFromJson(json);

  @override
  final double totalThisMonth;
  @override
  final double totalThisYear;
  @override
  final double totalAllTime;
  @override
  final int donationsThisMonth;
  @override
  final double percentageChange;

  @override
  String toString() {
    return 'GivingStats(totalThisMonth: $totalThisMonth, totalThisYear: $totalThisYear, totalAllTime: $totalAllTime, donationsThisMonth: $donationsThisMonth, percentageChange: $percentageChange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GivingStatsImpl &&
            (identical(other.totalThisMonth, totalThisMonth) ||
                other.totalThisMonth == totalThisMonth) &&
            (identical(other.totalThisYear, totalThisYear) ||
                other.totalThisYear == totalThisYear) &&
            (identical(other.totalAllTime, totalAllTime) ||
                other.totalAllTime == totalAllTime) &&
            (identical(other.donationsThisMonth, donationsThisMonth) ||
                other.donationsThisMonth == donationsThisMonth) &&
            (identical(other.percentageChange, percentageChange) ||
                other.percentageChange == percentageChange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalThisMonth,
    totalThisYear,
    totalAllTime,
    donationsThisMonth,
    percentageChange,
  );

  /// Create a copy of GivingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GivingStatsImplCopyWith<_$GivingStatsImpl> get copyWith =>
      __$$GivingStatsImplCopyWithImpl<_$GivingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GivingStatsImplToJson(this);
  }
}

abstract class _GivingStats implements GivingStats {
  const factory _GivingStats({
    required final double totalThisMonth,
    required final double totalThisYear,
    required final double totalAllTime,
    required final int donationsThisMonth,
    required final double percentageChange,
  }) = _$GivingStatsImpl;

  factory _GivingStats.fromJson(Map<String, dynamic> json) =
      _$GivingStatsImpl.fromJson;

  @override
  double get totalThisMonth;
  @override
  double get totalThisYear;
  @override
  double get totalAllTime;
  @override
  int get donationsThisMonth;
  @override
  double get percentageChange;

  /// Create a copy of GivingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GivingStatsImplCopyWith<_$GivingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttendanceStats _$AttendanceStatsFromJson(Map<String, dynamic> json) {
  return _AttendanceStats.fromJson(json);
}

/// @nodoc
mixin _$AttendanceStats {
  int get totalThisWeek => throw _privateConstructorUsedError;
  int get totalThisMonth => throw _privateConstructorUsedError;
  int get averagePerService => throw _privateConstructorUsedError;
  double get percentageChange => throw _privateConstructorUsedError;
  List<int> get last7Days => throw _privateConstructorUsedError;

  /// Serializes this AttendanceStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceStatsCopyWith<AttendanceStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceStatsCopyWith<$Res> {
  factory $AttendanceStatsCopyWith(
    AttendanceStats value,
    $Res Function(AttendanceStats) then,
  ) = _$AttendanceStatsCopyWithImpl<$Res, AttendanceStats>;
  @useResult
  $Res call({
    int totalThisWeek,
    int totalThisMonth,
    int averagePerService,
    double percentageChange,
    List<int> last7Days,
  });
}

/// @nodoc
class _$AttendanceStatsCopyWithImpl<$Res, $Val extends AttendanceStats>
    implements $AttendanceStatsCopyWith<$Res> {
  _$AttendanceStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalThisWeek = null,
    Object? totalThisMonth = null,
    Object? averagePerService = null,
    Object? percentageChange = null,
    Object? last7Days = null,
  }) {
    return _then(
      _value.copyWith(
            totalThisWeek: null == totalThisWeek
                ? _value.totalThisWeek
                : totalThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            totalThisMonth: null == totalThisMonth
                ? _value.totalThisMonth
                : totalThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            averagePerService: null == averagePerService
                ? _value.averagePerService
                : averagePerService // ignore: cast_nullable_to_non_nullable
                      as int,
            percentageChange: null == percentageChange
                ? _value.percentageChange
                : percentageChange // ignore: cast_nullable_to_non_nullable
                      as double,
            last7Days: null == last7Days
                ? _value.last7Days
                : last7Days // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceStatsImplCopyWith<$Res>
    implements $AttendanceStatsCopyWith<$Res> {
  factory _$$AttendanceStatsImplCopyWith(
    _$AttendanceStatsImpl value,
    $Res Function(_$AttendanceStatsImpl) then,
  ) = __$$AttendanceStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalThisWeek,
    int totalThisMonth,
    int averagePerService,
    double percentageChange,
    List<int> last7Days,
  });
}

/// @nodoc
class __$$AttendanceStatsImplCopyWithImpl<$Res>
    extends _$AttendanceStatsCopyWithImpl<$Res, _$AttendanceStatsImpl>
    implements _$$AttendanceStatsImplCopyWith<$Res> {
  __$$AttendanceStatsImplCopyWithImpl(
    _$AttendanceStatsImpl _value,
    $Res Function(_$AttendanceStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalThisWeek = null,
    Object? totalThisMonth = null,
    Object? averagePerService = null,
    Object? percentageChange = null,
    Object? last7Days = null,
  }) {
    return _then(
      _$AttendanceStatsImpl(
        totalThisWeek: null == totalThisWeek
            ? _value.totalThisWeek
            : totalThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        totalThisMonth: null == totalThisMonth
            ? _value.totalThisMonth
            : totalThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        averagePerService: null == averagePerService
            ? _value.averagePerService
            : averagePerService // ignore: cast_nullable_to_non_nullable
                  as int,
        percentageChange: null == percentageChange
            ? _value.percentageChange
            : percentageChange // ignore: cast_nullable_to_non_nullable
                  as double,
        last7Days: null == last7Days
            ? _value._last7Days
            : last7Days // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceStatsImpl implements _AttendanceStats {
  const _$AttendanceStatsImpl({
    required this.totalThisWeek,
    required this.totalThisMonth,
    required this.averagePerService,
    required this.percentageChange,
    required final List<int> last7Days,
  }) : _last7Days = last7Days;

  factory _$AttendanceStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceStatsImplFromJson(json);

  @override
  final int totalThisWeek;
  @override
  final int totalThisMonth;
  @override
  final int averagePerService;
  @override
  final double percentageChange;
  final List<int> _last7Days;
  @override
  List<int> get last7Days {
    if (_last7Days is EqualUnmodifiableListView) return _last7Days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_last7Days);
  }

  @override
  String toString() {
    return 'AttendanceStats(totalThisWeek: $totalThisWeek, totalThisMonth: $totalThisMonth, averagePerService: $averagePerService, percentageChange: $percentageChange, last7Days: $last7Days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceStatsImpl &&
            (identical(other.totalThisWeek, totalThisWeek) ||
                other.totalThisWeek == totalThisWeek) &&
            (identical(other.totalThisMonth, totalThisMonth) ||
                other.totalThisMonth == totalThisMonth) &&
            (identical(other.averagePerService, averagePerService) ||
                other.averagePerService == averagePerService) &&
            (identical(other.percentageChange, percentageChange) ||
                other.percentageChange == percentageChange) &&
            const DeepCollectionEquality().equals(
              other._last7Days,
              _last7Days,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalThisWeek,
    totalThisMonth,
    averagePerService,
    percentageChange,
    const DeepCollectionEquality().hash(_last7Days),
  );

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceStatsImplCopyWith<_$AttendanceStatsImpl> get copyWith =>
      __$$AttendanceStatsImplCopyWithImpl<_$AttendanceStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceStatsImplToJson(this);
  }
}

abstract class _AttendanceStats implements AttendanceStats {
  const factory _AttendanceStats({
    required final int totalThisWeek,
    required final int totalThisMonth,
    required final int averagePerService,
    required final double percentageChange,
    required final List<int> last7Days,
  }) = _$AttendanceStatsImpl;

  factory _AttendanceStats.fromJson(Map<String, dynamic> json) =
      _$AttendanceStatsImpl.fromJson;

  @override
  int get totalThisWeek;
  @override
  int get totalThisMonth;
  @override
  int get averagePerService;
  @override
  double get percentageChange;
  @override
  List<int> get last7Days;

  /// Create a copy of AttendanceStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceStatsImplCopyWith<_$AttendanceStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventStats _$EventStatsFromJson(Map<String, dynamic> json) {
  return _EventStats.fromJson(json);
}

/// @nodoc
mixin _$EventStats {
  int get upcomingEvents => throw _privateConstructorUsedError;
  int get totalRegistrations => throw _privateConstructorUsedError;
  int get eventsThisMonth => throw _privateConstructorUsedError;

  /// Serializes this EventStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventStatsCopyWith<EventStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventStatsCopyWith<$Res> {
  factory $EventStatsCopyWith(
    EventStats value,
    $Res Function(EventStats) then,
  ) = _$EventStatsCopyWithImpl<$Res, EventStats>;
  @useResult
  $Res call({int upcomingEvents, int totalRegistrations, int eventsThisMonth});
}

/// @nodoc
class _$EventStatsCopyWithImpl<$Res, $Val extends EventStats>
    implements $EventStatsCopyWith<$Res> {
  _$EventStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcomingEvents = null,
    Object? totalRegistrations = null,
    Object? eventsThisMonth = null,
  }) {
    return _then(
      _value.copyWith(
            upcomingEvents: null == upcomingEvents
                ? _value.upcomingEvents
                : upcomingEvents // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRegistrations: null == totalRegistrations
                ? _value.totalRegistrations
                : totalRegistrations // ignore: cast_nullable_to_non_nullable
                      as int,
            eventsThisMonth: null == eventsThisMonth
                ? _value.eventsThisMonth
                : eventsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventStatsImplCopyWith<$Res>
    implements $EventStatsCopyWith<$Res> {
  factory _$$EventStatsImplCopyWith(
    _$EventStatsImpl value,
    $Res Function(_$EventStatsImpl) then,
  ) = __$$EventStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int upcomingEvents, int totalRegistrations, int eventsThisMonth});
}

/// @nodoc
class __$$EventStatsImplCopyWithImpl<$Res>
    extends _$EventStatsCopyWithImpl<$Res, _$EventStatsImpl>
    implements _$$EventStatsImplCopyWith<$Res> {
  __$$EventStatsImplCopyWithImpl(
    _$EventStatsImpl _value,
    $Res Function(_$EventStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upcomingEvents = null,
    Object? totalRegistrations = null,
    Object? eventsThisMonth = null,
  }) {
    return _then(
      _$EventStatsImpl(
        upcomingEvents: null == upcomingEvents
            ? _value.upcomingEvents
            : upcomingEvents // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRegistrations: null == totalRegistrations
            ? _value.totalRegistrations
            : totalRegistrations // ignore: cast_nullable_to_non_nullable
                  as int,
        eventsThisMonth: null == eventsThisMonth
            ? _value.eventsThisMonth
            : eventsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventStatsImpl implements _EventStats {
  const _$EventStatsImpl({
    required this.upcomingEvents,
    required this.totalRegistrations,
    required this.eventsThisMonth,
  });

  factory _$EventStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventStatsImplFromJson(json);

  @override
  final int upcomingEvents;
  @override
  final int totalRegistrations;
  @override
  final int eventsThisMonth;

  @override
  String toString() {
    return 'EventStats(upcomingEvents: $upcomingEvents, totalRegistrations: $totalRegistrations, eventsThisMonth: $eventsThisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventStatsImpl &&
            (identical(other.upcomingEvents, upcomingEvents) ||
                other.upcomingEvents == upcomingEvents) &&
            (identical(other.totalRegistrations, totalRegistrations) ||
                other.totalRegistrations == totalRegistrations) &&
            (identical(other.eventsThisMonth, eventsThisMonth) ||
                other.eventsThisMonth == eventsThisMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    upcomingEvents,
    totalRegistrations,
    eventsThisMonth,
  );

  /// Create a copy of EventStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventStatsImplCopyWith<_$EventStatsImpl> get copyWith =>
      __$$EventStatsImplCopyWithImpl<_$EventStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventStatsImplToJson(this);
  }
}

abstract class _EventStats implements EventStats {
  const factory _EventStats({
    required final int upcomingEvents,
    required final int totalRegistrations,
    required final int eventsThisMonth,
  }) = _$EventStatsImpl;

  factory _EventStats.fromJson(Map<String, dynamic> json) =
      _$EventStatsImpl.fromJson;

  @override
  int get upcomingEvents;
  @override
  int get totalRegistrations;
  @override
  int get eventsThisMonth;

  /// Create a copy of EventStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventStatsImplCopyWith<_$EventStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberStats _$MemberStatsFromJson(Map<String, dynamic> json) {
  return _MemberStats.fromJson(json);
}

/// @nodoc
mixin _$MemberStats {
  int get totalMembers => throw _privateConstructorUsedError;
  int get newThisMonth => throw _privateConstructorUsedError;
  int get activeMembers => throw _privateConstructorUsedError;
  double get growthRate => throw _privateConstructorUsedError;

  /// Serializes this MemberStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberStatsCopyWith<MemberStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberStatsCopyWith<$Res> {
  factory $MemberStatsCopyWith(
    MemberStats value,
    $Res Function(MemberStats) then,
  ) = _$MemberStatsCopyWithImpl<$Res, MemberStats>;
  @useResult
  $Res call({
    int totalMembers,
    int newThisMonth,
    int activeMembers,
    double growthRate,
  });
}

/// @nodoc
class _$MemberStatsCopyWithImpl<$Res, $Val extends MemberStats>
    implements $MemberStatsCopyWith<$Res> {
  _$MemberStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? newThisMonth = null,
    Object? activeMembers = null,
    Object? growthRate = null,
  }) {
    return _then(
      _value.copyWith(
            totalMembers: null == totalMembers
                ? _value.totalMembers
                : totalMembers // ignore: cast_nullable_to_non_nullable
                      as int,
            newThisMonth: null == newThisMonth
                ? _value.newThisMonth
                : newThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            activeMembers: null == activeMembers
                ? _value.activeMembers
                : activeMembers // ignore: cast_nullable_to_non_nullable
                      as int,
            growthRate: null == growthRate
                ? _value.growthRate
                : growthRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberStatsImplCopyWith<$Res>
    implements $MemberStatsCopyWith<$Res> {
  factory _$$MemberStatsImplCopyWith(
    _$MemberStatsImpl value,
    $Res Function(_$MemberStatsImpl) then,
  ) = __$$MemberStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalMembers,
    int newThisMonth,
    int activeMembers,
    double growthRate,
  });
}

/// @nodoc
class __$$MemberStatsImplCopyWithImpl<$Res>
    extends _$MemberStatsCopyWithImpl<$Res, _$MemberStatsImpl>
    implements _$$MemberStatsImplCopyWith<$Res> {
  __$$MemberStatsImplCopyWithImpl(
    _$MemberStatsImpl _value,
    $Res Function(_$MemberStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? newThisMonth = null,
    Object? activeMembers = null,
    Object? growthRate = null,
  }) {
    return _then(
      _$MemberStatsImpl(
        totalMembers: null == totalMembers
            ? _value.totalMembers
            : totalMembers // ignore: cast_nullable_to_non_nullable
                  as int,
        newThisMonth: null == newThisMonth
            ? _value.newThisMonth
            : newThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        activeMembers: null == activeMembers
            ? _value.activeMembers
            : activeMembers // ignore: cast_nullable_to_non_nullable
                  as int,
        growthRate: null == growthRate
            ? _value.growthRate
            : growthRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberStatsImpl implements _MemberStats {
  const _$MemberStatsImpl({
    required this.totalMembers,
    required this.newThisMonth,
    required this.activeMembers,
    required this.growthRate,
  });

  factory _$MemberStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberStatsImplFromJson(json);

  @override
  final int totalMembers;
  @override
  final int newThisMonth;
  @override
  final int activeMembers;
  @override
  final double growthRate;

  @override
  String toString() {
    return 'MemberStats(totalMembers: $totalMembers, newThisMonth: $newThisMonth, activeMembers: $activeMembers, growthRate: $growthRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberStatsImpl &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.newThisMonth, newThisMonth) ||
                other.newThisMonth == newThisMonth) &&
            (identical(other.activeMembers, activeMembers) ||
                other.activeMembers == activeMembers) &&
            (identical(other.growthRate, growthRate) ||
                other.growthRate == growthRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalMembers,
    newThisMonth,
    activeMembers,
    growthRate,
  );

  /// Create a copy of MemberStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberStatsImplCopyWith<_$MemberStatsImpl> get copyWith =>
      __$$MemberStatsImplCopyWithImpl<_$MemberStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberStatsImplToJson(this);
  }
}

abstract class _MemberStats implements MemberStats {
  const factory _MemberStats({
    required final int totalMembers,
    required final int newThisMonth,
    required final int activeMembers,
    required final double growthRate,
  }) = _$MemberStatsImpl;

  factory _MemberStats.fromJson(Map<String, dynamic> json) =
      _$MemberStatsImpl.fromJson;

  @override
  int get totalMembers;
  @override
  int get newThisMonth;
  @override
  int get activeMembers;
  @override
  double get growthRate;

  /// Create a copy of MemberStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberStatsImplCopyWith<_$MemberStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
