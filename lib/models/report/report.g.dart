// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      uid: json['uid'] as String? ?? '',
      injuryStatus: (json['injuryStatus'] as num?)?.toInt() ?? 0,
      attendOfficeStatus: (json['attendOfficeStatus'] as num?)?.toInt() ?? 0,
      location: json['location'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isConfirmed: json['isConfirmed'] as bool? ?? false,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'injuryStatus': instance.injuryStatus,
      'attendOfficeStatus': instance.attendOfficeStatus,
      'location': instance.location,
      'message': instance.message,
      'isConfirmed': instance.isConfirmed,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
