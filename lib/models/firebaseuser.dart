import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "firebaseuser.freezed.dart";
part "firebaseuser.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
class FirebaseUser with _$FirebaseUser {
  const factory FirebaseUser({
    @Default('') String uid,
    @Default('') String name,
    @Default('') String email,
    @Default('') String imagepath,
    @Default(false) bool isAdmin,
    @TimestampConverter() DateTime? createdAt,
  }) = _FirebaseUser;

  // Tagからデータを取得する際の変換処理
  factory FirebaseUser.fromJson(Map<String, dynamic> json) =>
    _$FirebaseUserFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'imagepath': imagepath,
    'isAdmin': isAdmin,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };
}
