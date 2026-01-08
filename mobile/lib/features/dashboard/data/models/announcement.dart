import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';

/// Announcement model for dashboard
@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String message,
    required String category,
    required DateTime createdAt,
    String? imageUrl,
    @Default(false) bool isRead,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}
