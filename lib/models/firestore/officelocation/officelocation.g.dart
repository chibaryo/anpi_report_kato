// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'officelocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfficeLocation _$OfficeLocationFromJson(Map<String, dynamic> json) =>
    _OfficeLocation(
      displayName: json['displayName'] as String? ?? '',
      sortNumber: (json['sortNumber'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$OfficeLocationToJson(_OfficeLocation instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'sortNumber': instance.sortNumber,
      'isActive': instance.isActive,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
