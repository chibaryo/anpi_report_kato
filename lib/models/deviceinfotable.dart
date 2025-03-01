import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "deviceinfotable.freezed.dart";
part "deviceinfotable.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class DeviceInfoTable with _$DeviceInfoTable {
  const factory DeviceInfoTable({
    @Default('') String systemName,
    @Default('') String osVersion,
    @Default('') String localizedModel,
    @Default('') String productName,
    @Default('') String udId,
    @Default('') String fcmToken,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _DeviceInfoTable;

  // Tagからデータを取得する際の変換処理
  factory DeviceInfoTable.fromJson(Map<String, dynamic> json) =>
    _$DeviceInfoTableFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'systemName': systemName,
    'osVersion': osVersion,
    'localizedModel': localizedModel,
    'productName': productName,
    'udId': udId,
    'fcmToken': fcmToken,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}
