import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part "firestoreuser.freezed.dart";
part "firestoreuser.g.dart";

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}

@freezed
abstract class FirestoreUser with _$FirestoreUser {
  const factory FirestoreUser({
    @Default('') String username,
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isOnline,
    @TimestampConverter() DateTime? lastActive,
    @Default(0) int accoutStatus,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _FirestoreUser;

  // Tagからデータを取得する際の変換処理
  factory FirestoreUser.fromJson(Map<String, dynamic> json) =>
    _$FirestoreUserFromJson(json).copyWith(
      lastActive: (json['lastActive'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'isOnline': isOnline,
    'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    'accoutStatus': accoutStatus,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}