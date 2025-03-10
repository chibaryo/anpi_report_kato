import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'converter/document_reference_converter.dart';

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
abstract class UserReport with _$UserReport {
  const factory UserReport({
    @Default('') String uid,
    @Default('') String notificationId,
    @DocumentReferenceConverter() required DocumentReference userRef,
    @DocumentReferenceConverter() required DocumentReference profileRef,
    @Default(<String, dynamic>{}) Map<String, dynamic> reportContents,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
 }) = _UserReport;

  // Tagからデータを取得する際の変換処理
  factory UserReport.fromJson(Map<String, dynamic> json) =>
    _$UserReportFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'notificationId': notificationId,
    'userRef': userRef,
    'profileRef': profileRef,
    'reportContents': reportContents,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}