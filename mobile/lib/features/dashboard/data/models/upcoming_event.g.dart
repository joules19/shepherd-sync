// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpcomingEventImpl _$$UpcomingEventImplFromJson(Map<String, dynamic> json) =>
    _$UpcomingEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      registeredCount: (json['registeredCount'] as num).toInt(),
      maxCapacity: (json['maxCapacity'] as num).toInt(),
      isRegistered: json['isRegistered'] as bool? ?? false,
    );

Map<String, dynamic> _$$UpcomingEventImplToJson(_$UpcomingEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'location': instance.location,
      'imageUrl': instance.imageUrl,
      'registeredCount': instance.registeredCount,
      'maxCapacity': instance.maxCapacity,
      'isRegistered': instance.isRegistered,
    };
