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
class Notification with _$Notification {
  const factory Notification({
    @Default('') String notificationId,
    @Default('') String notiTitle,
    @Default('') String notiBody,
    @Default([]) List<String> a_respondents,
    @TimestampConverter() DateTime? createdAt,
  }) = _Notification;

  // Tagからデータを取得する際の変換処理
  @override
  factory Notification.fromJson(Map<String, dynamic> json) =>
    _$NotificationFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'notificationId': notificationId,
    'notiTitle': notiTitle,
    'notiBody': notiBody,
    'a_respondents': a_respondents,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };
}
