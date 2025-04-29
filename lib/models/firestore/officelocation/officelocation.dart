import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "officelocation.freezed.dart";
part "officelocation.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
    object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class OfficeLocation with _$OfficeLocation {
  const factory OfficeLocation({
    @Default('') String displayName,
    @Default(0) int sortNumber,
    @Default(true) bool isActive,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _OfficeLocation;

  // Tagからデータを取得する際の変換処理
  factory OfficeLocation.fromJson(Map<String, dynamic> json) =>
    _$OfficeLocationFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'sortNumber': sortNumber,
    'isActive': isActive,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}