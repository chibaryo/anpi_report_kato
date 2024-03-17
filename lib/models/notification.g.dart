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
      a_respondents: (json['a_respondents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'notiTitle': instance.notiTitle,
      'notiBody': instance.notiBody,
      'a_respondents': instance.a_respondents,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
