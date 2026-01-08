import 'package:freezed_annotation/freezed_annotation.dart';

part 'upcoming_event.freezed.dart';
part 'upcoming_event.g.dart';

/// Upcoming event model for dashboard preview
@freezed
class UpcomingEvent with _$UpcomingEvent {
  const factory UpcomingEvent({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    String? imageUrl,
    required int registeredCount,
    required int maxCapacity,
    @Default(false) bool isRegistered,
  }) = _UpcomingEvent;

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) =>
      _$UpcomingEventFromJson(json);
}
