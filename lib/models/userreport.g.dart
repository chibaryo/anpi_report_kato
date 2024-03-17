// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userreport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserReportImpl _$$UserReportImplFromJson(Map<String, dynamic> json) =>
    _$UserReportImpl(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      anpiStatus: json['anpiStatus'] as String? ?? '',
      gotoOfficeStatus: json['gotoOfficeStatus'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isLocationPermitted: json['isLocationPermitted'] as bool? ?? false,
      position: (json['position'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$UserReportImplToJson(_$UserReportImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'anpiStatus': instance.anpiStatus,
      'gotoOfficeStatus': instance.gotoOfficeStatus,
      'message': instance.message,
      'isLocationPermitted': instance.isLocationPermitted,
      'position': instance.position,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
