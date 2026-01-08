import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required GivingStats giving,
    required MemberStats members,
    required EventStats events,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);
}

@freezed
class GivingStats with _$GivingStats {
  const factory GivingStats({
    required double totalAmount,
    required int totalDonations,
    required double averageDonation,
    required int recurringDonations,
  }) = _GivingStats;

  factory GivingStats.fromJson(Map<String, dynamic> json) => _$GivingStatsFromJson(json);
}

@freezed
class MemberStats with _$MemberStats {
  const factory MemberStats({
    required int totalMembers,
    required int activeMembers,
    required int visitors,
    required int newMembers,
    required int recentBaptisms,
  }) = _MemberStats;

  factory MemberStats.fromJson(Map<String, dynamic> json) => _$MemberStatsFromJson(json);
}

@freezed
class EventStats with _$EventStats {
  const factory EventStats({
    required int totalEvents,
    required int upcomingEvents,
    required int completedEvents,
    required int draftEvents,
    required int totalRegistrations,
  }) = _EventStats;

  factory EventStats.fromJson(Map<String, dynamic> json) => _$EventStatsFromJson(json);
}

@freezed
class UpcomingEvent with _$UpcomingEvent {
  const factory UpcomingEvent({
    required String id,
    required String title,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    required bool isVirtual,
    String? coverImage,
    required EventCreator creator,
    @JsonKey(name: '_count') required EventCount count,
  }) = _UpcomingEvent;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) => _$UpcomingEventFromJson(json);
}

@freezed
class EventCreator with _$EventCreator {
  const factory EventCreator({
    required String id,
    required String firstName,
    required String lastName,
  }) = _EventCreator;

  factory EventCreator.fromJson(Map<String, dynamic> json) => _$EventCreatorFromJson(json);
}

@freezed
class EventCount with _$EventCount {
  const factory EventCount({
    required int registrations,
  }) = _EventCount;

  factory EventCount.fromJson(Map<String, dynamic> json) => _$EventCountFromJson(json);
}

@freezed
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> data,
    required int total,
    required int page,
    required int limit,
  }) = _PaginatedResult<T>;

  factory PaginatedResult.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) => _$PaginatedResultFromJson<T>(json, fromJsonT);
}
