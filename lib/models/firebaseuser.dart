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
    @Default('') String password,
//    @Default('') String imagepath,
    @Default(false) bool isAdmin,
    @Default('') String officeLocation,
    @Default(<String>[]) List<String> department, // Add the department field
    @Default('') String jobLevel,
//    @Default(false) bool isOnline,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _FirebaseUser;

  // Tagからデータを取得する際の変換処理
  factory FirebaseUser.fromJson(Map<String, dynamic> json) =>
    _$FirebaseUserFromJson(json).copyWith(
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );

  // DartのオブジェクトからFirebaseへ渡す際の変換処理
  @override
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'password': password,
//    'imagepath': imagepath,
    'isAdmin': isAdmin,
//    'isOnline': isOnline,
    'officeLocation': officeLocation,
    'department': department, // Add department to toJson method
    'jobLevel': jobLevel,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };
}
