// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userreport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserReport _$UserReportFromJson(Map<String, dynamic> json) => _UserReport(
      uid: json['uid'] as String? ?? '',
      notificationId: json['notificationId'] as String? ?? '',
      userRef: const DocumentReferenceConverter()
          .fromJson(json['userRef'] as DocumentReference<Object?>),
      profileRef: const DocumentReferenceConverter()
          .fromJson(json['profileRef'] as DocumentReference<Object?>),
      reportContents: json['reportContents'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$UserReportToJson(_UserReport instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'notificationId': instance.notificationId,
      'userRef': const DocumentReferenceConverter().toJson(instance.userRef),
      'profileRef':
          const DocumentReferenceConverter().toJson(instance.profileRef),
      'reportContents': instance.reportContents,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
