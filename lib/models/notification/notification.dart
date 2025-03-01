import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "notification.freezed.dart";
part "notification.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class Noti with _$Noti {
  const factory Noti({
    @Default('') String notificationId,
    @Default('') String notiTitle,
    @Default('') String notiBody,
    @Default(0) int notiType,
    @Default('') String notiTopic,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Noti;

  // Tagからデータを取得する際の変換処理
  @override
  factory Noti.fromJson(Map<String, dynamic> json) =>
    _$NotiFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'notificationId': notificationId,
    'notiTitle': notiTitle,
    'notiBody': notiBody,
    'notiType': notiType,
    'notiTopic': notiTopic,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}