// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotiImpl _$$NotiImplFromJson(Map<String, dynamic> json) => _$NotiImpl(
      notificationId: json['notificationId'] as String? ?? '',
      notiTitle: json['notiTitle'] as String? ?? '',
      notiBody: json['notiBody'] as String? ?? '',
      notiType: (json['notiType'] as num?)?.toInt() ?? 1,
      notiTopic: json['notiTopic'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$NotiImplToJson(_$NotiImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'notiTitle': instance.notiTitle,
      'notiBody': instance.notiBody,
      'notiType': instance.notiType,
      'notiTopic': instance.notiTopic,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
