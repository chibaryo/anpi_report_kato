import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "userreport.freezed.dart";
part "userreport.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class UserReport with _$UserReport {
  const factory UserReport({
    @Default('') String uid,
    @Default('') String name,
    @Default('') String anpiStatus,
    @Default('') String gotoOfficeStatus,
    @Default('') String message,
    @Default(false) bool isLocationPermitted,
    @Default([]) List<String> position, // latitude, longitude, altitude
    @TimestampConverter() DateTime? createdAt,
  }) = _UserReport;

  // Tagからデータを取得する際の変換処理
  factory UserReport.fromJson(Map<String, dynamic> json) =>
    _$UserReportFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'anpiStatus': anpiStatus,
    'gotoOfficeStatus': gotoOfficeStatus,
    'message': message,
    'isLocationPermitted': isLocationPermitted,
    'position': position,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };
}
