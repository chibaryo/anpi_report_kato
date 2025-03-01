import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "prevnotis.freezed.dart";
part "prevnotis.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class PrevNotis with _$PrevNotis {
  const factory PrevNotis({
    @Default('') String notificationId,
    @Default('') String uid,
    @Default(false) bool isMeResponded,
    @TimestampConverter() DateTime? createdAt,
  }) = _PrevNotis;

  // Tagからデータを取得する際の変換処理
  factory PrevNotis.fromJson(Map<String, dynamic> json) =>
    _$PrevNotisFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'notificationId': notificationId,
    'uid': uid,
    'isMeResponded': isMeResponded,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };
}
