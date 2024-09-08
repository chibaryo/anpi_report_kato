// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestoreuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FirestoreUserImpl _$$FirestoreUserImplFromJson(Map<String, dynamic> json) =>
    _$FirestoreUserImpl(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      lastActive:
          const TimestampConverter().fromJson(json['lastActive'] as Timestamp?),
      accoutStatus: (json['accoutStatus'] as num?)?.toInt() ?? 0,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$FirestoreUserImplToJson(_$FirestoreUserImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'isOnline': instance.isOnline,
      'lastActive': const TimestampConverter().toJson(instance.lastActive),
      'accoutStatus': instance.accoutStatus,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
