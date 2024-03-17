// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prevnotis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrevNotisImpl _$$PrevNotisImplFromJson(Map<String, dynamic> json) =>
    _$PrevNotisImpl(
      notificationId: json['notificationId'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      isMeResponded: json['isMeResponded'] as bool? ?? false,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$PrevNotisImplToJson(_$PrevNotisImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'uid': instance.uid,
      'isMeResponded': instance.isMeResponded,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
