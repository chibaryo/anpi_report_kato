// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceinfotable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceInfoTable _$DeviceInfoTableFromJson(Map<String, dynamic> json) =>
    _DeviceInfoTable(
      systemName: json['systemName'] as String? ?? '',
      osVersion: json['osVersion'] as String? ?? '',
      localizedModel: json['localizedModel'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      udId: json['udId'] as String? ?? '',
      fcmToken: json['fcmToken'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$DeviceInfoTableToJson(_DeviceInfoTable instance) =>
    <String, dynamic>{
      'systemName': instance.systemName,
      'osVersion': instance.osVersion,
      'localizedModel': instance.localizedModel,
      'productName': instance.productName,
      'udId': instance.udId,
      'fcmToken': instance.fcmToken,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
