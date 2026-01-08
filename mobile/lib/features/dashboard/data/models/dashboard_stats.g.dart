// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      giving: GivingStats.fromJson(json['giving'] as Map<String, dynamic>),
      attendance: AttendanceStats.fromJson(
        json['attendance'] as Map<String, dynamic>,
      ),
      events: EventStats.fromJson(json['events'] as Map<String, dynamic>),
      members: MemberStats.fromJson(json['members'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'giving': instance.giving,
  'attendance': instance.attendance,
  'events': instance.events,
  'members': instance.members,
};

_$GivingStatsImpl _$$GivingStatsImplFromJson(Map<String, dynamic> json) =>
    _$GivingStatsImpl(
      totalThisMonth: (json['totalThisMonth'] as num).toDouble(),
      totalThisYear: (json['totalThisYear'] as num).toDouble(),
      totalAllTime: (json['totalAllTime'] as num).toDouble(),
      donationsThisMonth: (json['donationsThisMonth'] as num).toInt(),
      percentageChange: (json['percentageChange'] as num).toDouble(),
    );

Map<String, dynamic> _$$GivingStatsImplToJson(_$GivingStatsImpl instance) =>
    <String, dynamic>{
      'totalThisMonth': instance.totalThisMonth,
      'totalThisYear': instance.totalThisYear,
      'totalAllTime': instance.totalAllTime,
      'donationsThisMonth': instance.donationsThisMonth,
      'percentageChange': instance.percentageChange,
    };

_$AttendanceStatsImpl _$$AttendanceStatsImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceStatsImpl(
  totalThisWeek: (json['totalThisWeek'] as num).toInt(),
  totalThisMonth: (json['totalThisMonth'] as num).toInt(),
  averagePerService: (json['averagePerService'] as num).toInt(),
  percentageChange: (json['percentageChange'] as num).toDouble(),
  last7Days: (json['last7Days'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$$AttendanceStatsImplToJson(
  _$AttendanceStatsImpl instance,
) => <String, dynamic>{
  'totalThisWeek': instance.totalThisWeek,
  'totalThisMonth': instance.totalThisMonth,
  'averagePerService': instance.averagePerService,
  'percentageChange': instance.percentageChange,
  'last7Days': instance.last7Days,
};

_$EventStatsImpl _$$EventStatsImplFromJson(Map<String, dynamic> json) =>
    _$EventStatsImpl(
      upcomingEvents: (json['upcomingEvents'] as num).toInt(),
      totalRegistrations: (json['totalRegistrations'] as num).toInt(),
      eventsThisMonth: (json['eventsThisMonth'] as num).toInt(),
    );

Map<String, dynamic> _$$EventStatsImplToJson(_$EventStatsImpl instance) =>
    <String, dynamic>{
      'upcomingEvents': instance.upcomingEvents,
      'totalRegistrations': instance.totalRegistrations,
      'eventsThisMonth': instance.eventsThisMonth,
    };

_$MemberStatsImpl _$$MemberStatsImplFromJson(Map<String, dynamic> json) =>
    _$MemberStatsImpl(
      totalMembers: (json['totalMembers'] as num).toInt(),
      newThisMonth: (json['newThisMonth'] as num).toInt(),
      activeMembers: (json['activeMembers'] as num).toInt(),
      growthRate: (json['growthRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$MemberStatsImplToJson(_$MemberStatsImpl instance) =>
    <String, dynamic>{
      'totalMembers': instance.totalMembers,
      'newThisMonth': instance.newThisMonth,
      'activeMembers': instance.activeMembers,
      'growthRate': instance.growthRate,
    };
