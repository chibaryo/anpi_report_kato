import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "deviceinfo.freezed.dart";
part "deviceinfo.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    @Default('') String udId,
    @Default('') String osName,
    @Default('') String osVersion,
    @Default('') String productName,
    @Default(<String, dynamic>{}) Map<String, dynamic> fcmTokens,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _DeviceInfo;

  // Tagからデータを取得する際の変換処理
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
    _$DeviceInfoFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'udId': udId,
    'osName': osName,
    'osVersion': osVersion,
    'productName': productName,
    'fcmTokens': fcmTokens,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}