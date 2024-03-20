import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "notitemplate.freezed.dart";
part "notitemplate.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class NotiTemplate with _$NotiTemplate {
  const factory NotiTemplate({
    @Default('') String notiTemplateId,
    @Default('') String notiTitle,
    @Default('') String notiBody,
    @TimestampConverter() DateTime? createdAt,
  }) = _NotiTemplate;

  // Tagからデータを取得する際の変換処理
  @override
  factory NotiTemplate.fromJson(Map<String, dynamic> json) =>
    _$NotiTemplateFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'notiTemplateId': notiTemplateId,
    'notiTitle': notiTitle,
    'notiBody': notiBody,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };
}
