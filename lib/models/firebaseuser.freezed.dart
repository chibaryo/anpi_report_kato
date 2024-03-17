// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firebaseuser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FirebaseUser _$FirebaseUserFromJson(Map<String, dynamic> json) {
  return _FirebaseUser.fromJson(json);
}

/// @nodoc
mixin _$FirebaseUser {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get imagepath => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirebaseUserCopyWith<FirebaseUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseUserCopyWith<$Res> {
  factory $FirebaseUserCopyWith(
          FirebaseUser value, $Res Function(FirebaseUser) then) =
      _$FirebaseUserCopyWithImpl<$Res, FirebaseUser>;
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String imagepath,
      bool isAdmin,
      bool isOnline,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$FirebaseUserCopyWithImpl<$Res, $Val extends FirebaseUser>
    implements $FirebaseUserCopyWith<$Res> {
  _$FirebaseUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? imagepath = null,
    Object? isAdmin = null,
    Object? isOnline = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      imagepath: null == imagepath
          ? _value.imagepath
          : imagepath // ignore: cast_nullable_to_non_nullable
              as String,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FirebaseUserImplCopyWith<$Res>
    implements $FirebaseUserCopyWith<$Res> {
  factory _$$FirebaseUserImplCopyWith(
          _$FirebaseUserImpl value, $Res Function(_$FirebaseUserImpl) then) =
      __$$FirebaseUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String email,
      String imagepath,
      bool isAdmin,
      bool isOnline,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$$FirebaseUserImplCopyWithImpl<$Res>
    extends _$FirebaseUserCopyWithImpl<$Res, _$FirebaseUserImpl>
    implements _$$FirebaseUserImplCopyWith<$Res> {
  __$$FirebaseUserImplCopyWithImpl(
      _$FirebaseUserImpl _value, $Res Function(_$FirebaseUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? imagepath = null,
    Object? isAdmin = null,
    Object? isOnline = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$FirebaseUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      imagepath: null == imagepath
          ? _value.imagepath
          : imagepath // ignore: cast_nullable_to_non_nullable
              as String,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FirebaseUserImpl with DiagnosticableTreeMixin implements _FirebaseUser {
  const _$FirebaseUserImpl(
      {this.uid = '',
      this.name = '',
      this.email = '',
      this.imagepath = '',
      this.isAdmin = false,
      this.isOnline = false,
      @TimestampConverter() this.createdAt});

  factory _$FirebaseUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$FirebaseUserImplFromJson(json);

  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String imagepath;
  @override
  @JsonKey()
  final bool isAdmin;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FirebaseUser(uid: $uid, name: $name, email: $email, imagepath: $imagepath, isAdmin: $isAdmin, isOnline: $isOnline, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FirebaseUser'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('imagepath', imagepath))
      ..add(DiagnosticsProperty('isAdmin', isAdmin))
      ..add(DiagnosticsProperty('isOnline', isOnline))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirebaseUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.imagepath, imagepath) ||
                other.imagepath == imagepath) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, name, email, imagepath, isAdmin, isOnline, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FirebaseUserImplCopyWith<_$FirebaseUserImpl> get copyWith =>
      __$$FirebaseUserImplCopyWithImpl<_$FirebaseUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FirebaseUserImplToJson(
      this,
    );
  }
}

abstract class _FirebaseUser implements FirebaseUser {
  const factory _FirebaseUser(
      {final String uid,
      final String name,
      final String email,
      final String imagepath,
      final bool isAdmin,
      final bool isOnline,
      @TimestampConverter() final DateTime? createdAt}) = _$FirebaseUserImpl;

  factory _FirebaseUser.fromJson(Map<String, dynamic> json) =
      _$FirebaseUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get email;
  @override
  String get imagepath;
  @override
  bool get isAdmin;
  @override
  bool get isOnline;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FirebaseUserImplCopyWith<_$FirebaseUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
