// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      udId: json['udId'] as String? ?? '',
      osName: json['osName'] as String? ?? '',
      osVersion: json['osVersion'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      fcmTokens: json['fcmTokens'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'udId': instance.udId,
      'osName': instance.osName,
      'osVersion': instance.osVersion,
      'productName': instance.productName,
      'fcmTokens': instance.fcmTokens,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
