import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "topic.freezed.dart";
part "topic.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
    object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class Topic with _$Topic {
  const factory Topic({
    @Default('') String displayName,
    @Default('') String topic,
    @Default(0) int sortNumber,
    @Default(0) int bitMaskNum,
    @Default(true) bool isActive,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Topic;

  // Tagからデータを取得する際の変換処理
  factory Topic.fromJson(Map<String, dynamic> json) =>
    _$TopicFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'topic': topic,
    'sortNumber': sortNumber,
    'bitMaskNum': bitMaskNum,
    'isActive': isActive,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}