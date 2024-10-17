import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part "report.freezed.dart";
part "report.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class Report with _$Report {
  const factory Report({
    @Default('') String uid,
    @Default('') String notificationId,
    @Default(<String, dynamic>{}) Map<String, dynamic> reportContents,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
 }) = _Report;

  // Tagからデータを取得する際の変換処理
  factory Report.fromJson(Map<String, dynamic> json) =>
    _$ReportFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'notificationId': notificationId,
    'reportContents': reportContents,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}