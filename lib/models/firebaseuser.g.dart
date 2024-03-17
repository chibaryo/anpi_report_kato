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
      imagepath: json['imagepath'] as String? ?? '',
      isAdmin: json['isAdmin'] as bool? ?? false,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$$FirebaseUserImplToJson(_$FirebaseUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'imagepath': instance.imagepath,
      'isAdmin': instance.isAdmin,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
