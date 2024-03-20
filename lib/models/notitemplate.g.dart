// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notitemplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotiTemplateImpl _$$NotiTemplateImplFromJson(Map<String, dynamic> json) =>
    _$NotiTemplateImpl(
      notiTemplateId: json['notiTemplateId'] as String? ?? '',
      notiTitle: json['notiTitle'] as String? ?? '',
      notiBody: json['notiBody'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$NotiTemplateImplToJson(_$NotiTemplateImpl instance) =>
    <String, dynamic>{
      'notiTemplateId': instance.notiTemplateId,
      'notiTitle': instance.notiTitle,
      'notiBody': instance.notiBody,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
