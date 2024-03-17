// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prevnotis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrevNotis _$PrevNotisFromJson(Map<String, dynamic> json) {
  return _PrevNotis.fromJson(json);
}

/// @nodoc
mixin _$PrevNotis {
  String get notificationId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  bool get isMeResponded => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrevNotisCopyWith<PrevNotis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrevNotisCopyWith<$Res> {
  factory $PrevNotisCopyWith(PrevNotis value, $Res Function(PrevNotis) then) =
      _$PrevNotisCopyWithImpl<$Res, PrevNotis>;
  @useResult
  $Res call(
      {String notificationId,
      String uid,
      bool isMeResponded,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$PrevNotisCopyWithImpl<$Res, $Val extends PrevNotis>
    implements $PrevNotisCopyWith<$Res> {
  _$PrevNotisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? uid = null,
    Object? isMeResponded = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      isMeResponded: null == isMeResponded
          ? _value.isMeResponded
          : isMeResponded // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrevNotisImplCopyWith<$Res>
    implements $PrevNotisCopyWith<$Res> {
  factory _$$PrevNotisImplCopyWith(
          _$PrevNotisImpl value, $Res Function(_$PrevNotisImpl) then) =
      __$$PrevNotisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String uid,
      bool isMeResponded,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$$PrevNotisImplCopyWithImpl<$Res>
    extends _$PrevNotisCopyWithImpl<$Res, _$PrevNotisImpl>
    implements _$$PrevNotisImplCopyWith<$Res> {
  __$$PrevNotisImplCopyWithImpl(
      _$PrevNotisImpl _value, $Res Function(_$PrevNotisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? uid = null,
    Object? isMeResponded = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$PrevNotisImpl(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      isMeResponded: null == isMeResponded
          ? _value.isMeResponded
          : isMeResponded // ignore: cast_nullable_to_non_nullable
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
class _$PrevNotisImpl with DiagnosticableTreeMixin implements _PrevNotis {
  const _$PrevNotisImpl(
      {this.notificationId = '',
      this.uid = '',
      this.isMeResponded = false,
      @TimestampConverter() this.createdAt});

  factory _$PrevNotisImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrevNotisImplFromJson(json);

  @override
  @JsonKey()
  final String notificationId;
  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final bool isMeResponded;
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PrevNotis(notificationId: $notificationId, uid: $uid, isMeResponded: $isMeResponded, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PrevNotis'))
      ..add(DiagnosticsProperty('notificationId', notificationId))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('isMeResponded', isMeResponded))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrevNotisImpl &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.isMeResponded, isMeResponded) ||
                other.isMeResponded == isMeResponded) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notificationId, uid, isMeResponded, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrevNotisImplCopyWith<_$PrevNotisImpl> get copyWith =>
      __$$PrevNotisImplCopyWithImpl<_$PrevNotisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrevNotisImplToJson(
      this,
    );
  }
}

abstract class _PrevNotis implements PrevNotis {
  const factory _PrevNotis(
      {final String notificationId,
      final String uid,
      final bool isMeResponded,
      @TimestampConverter() final DateTime? createdAt}) = _$PrevNotisImpl;

  factory _PrevNotis.fromJson(Map<String, dynamic> json) =
      _$PrevNotisImpl.fromJson;

  @override
  String get notificationId;
  @override
  String get uid;
  @override
  bool get isMeResponded;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PrevNotisImplCopyWith<_$PrevNotisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
