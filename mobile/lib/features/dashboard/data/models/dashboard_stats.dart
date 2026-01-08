import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

/// Dashboard statistics model
@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required GivingStats giving,
    required AttendanceStats attendance,
    required EventStats events,
    required MemberStats members,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}

/// Giving statistics
@freezed
class GivingStats with _$GivingStats {
  const factory GivingStats({
    required double totalThisMonth,
    required double totalThisYear,
    required double totalAllTime,
    required int donationsThisMonth,
    required double percentageChange,
  }) = _GivingStats;

  factory GivingStats.fromJson(Map<String, dynamic> json) =>
      _$GivingStatsFromJson(json);
}

/// Attendance statistics
@freezed
class AttendanceStats with _$AttendanceStats {
  const factory AttendanceStats({
    required int totalThisWeek,
    required int totalThisMonth,
    required int averagePerService,
    required double percentageChange,
    required List<int> last7Days,
  }) = _AttendanceStats;

  factory AttendanceStats.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatsFromJson(json);
}

/// Event statistics
@freezed
class EventStats with _$EventStats {
  const factory EventStats({
    required int upcomingEvents,
    required int totalRegistrations,
    required int eventsThisMonth,
  }) = _EventStats;

  factory EventStats.fromJson(Map<String, dynamic> json) =>
      _$EventStatsFromJson(json);
}

/// Member statistics
@freezed
class MemberStats with _$MemberStats {
  const factory MemberStats({
    required int totalMembers,
    required int newThisMonth,
    required int activeMembers,
    required double growthRate,
  }) = _MemberStats;

  factory MemberStats.fromJson(Map<String, dynamic> json) =>
      _$MemberStatsFromJson(json);
}
