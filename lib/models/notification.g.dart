// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      notificationId: json['notificationId'] as String? ?? '',
      notiTitle: json['notiTitle'] as String? ?? '',
      notiBody: json['notiBody'] as String? ?? '',
      notiTopic: json['notiTopic'] as String? ?? '',
      notiType: json['notiType'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'notiTitle': instance.notiTitle,
      'notiBody': instance.notiBody,
      'notiTopic': instance.notiTopic,
      'notiType': instance.notiType,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
