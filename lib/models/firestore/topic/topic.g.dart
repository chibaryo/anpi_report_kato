// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
      displayName: json['displayName'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      sortNumber: (json['sortNumber'] as num?)?.toInt() ?? 0,
      bitMaskNum: (json['bitMaskNum'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'topic': instance.topic,
      'sortNumber': instance.sortNumber,
      'bitMaskNum': instance.bitMaskNum,
      'isActive': instance.isActive,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
