// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Noti _$NotiFromJson(Map<String, dynamic> json) => _Noti(
      notificationId: json['notificationId'] as String? ?? '',
      notiTitle: json['notiTitle'] as String? ?? '',
      notiBody: json['notiBody'] as String? ?? '',
      notiType: (json['notiType'] as num?)?.toInt() ?? 0,
      notiTopic: json['notiTopic'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$NotiToJson(_Noti instance) => <String, dynamic>{
      'notificationId': instance.notificationId,
      'notiTitle': instance.notiTitle,
      'notiBody': instance.notiBody,
      'notiType': instance.notiType,
      'notiTopic': instance.notiTopic,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
