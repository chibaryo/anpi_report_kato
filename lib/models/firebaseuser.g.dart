// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebaseuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FirebaseUserImpl _$$FirebaseUserImplFromJson(Map<String, dynamic> json) =>
    _$FirebaseUserImpl(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isAdmin: json['isAdmin'] as bool? ?? false,
      officeLocation: json['officeLocation'] as String? ?? '',
      department: (json['department'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      jobLevel: json['jobLevel'] as String? ?? '',
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp?),
    );

Map<String, dynamic> _$$FirebaseUserImplToJson(_$FirebaseUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'isAdmin': instance.isAdmin,
      'officeLocation': instance.officeLocation,
      'department': instance.department,
      'jobLevel': instance.jobLevel,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
