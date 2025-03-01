// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prevnotis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrevNotis _$PrevNotisFromJson(Map<String, dynamic> json) => _PrevNotis(
      notificationId: json['notificationId'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      isMeResponded: json['isMeResponded'] as bool? ?? false,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$PrevNotisToJson(_PrevNotis instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'uid': instance.uid,
      'isMeResponded': instance.isMeResponded,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
