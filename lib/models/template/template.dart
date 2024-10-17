import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part "template.freezed.dart";
part "template.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class Template with _$Template {
  const factory Template({
    @Default('') String notiTitle,
    @Default('') String notiBody,
    @TimestampConverter() DateTime? createdAt,
     @TimestampConverter() DateTime? updatedAt,
 }) = _Template;

  // Tagからデータを取得する際の変換処理
  factory Template.fromJson(Map<String, dynamic> json) =>
    _$TemplateFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'notiTitle': notiTitle,
    'notiBody': notiBody,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}