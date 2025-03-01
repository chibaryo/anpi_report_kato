// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prevnotis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrevNotis implements DiagnosticableTreeMixin {
  String get notificationId;
  String get uid;
  bool get isMeResponded;
  @TimestampConverter()
  DateTime? get createdAt;

  /// Create a copy of PrevNotis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PrevNotisCopyWith<PrevNotis> get copyWith =>
      _$PrevNotisCopyWithImpl<PrevNotis>(this as PrevNotis, _$identity);

  /// Serializes this PrevNotis to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is PrevNotis &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.isMeResponded, isMeResponded) ||
                other.isMeResponded == isMeResponded) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notificationId, uid, isMeResponded, createdAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PrevNotis(notificationId: $notificationId, uid: $uid, isMeResponded: $isMeResponded, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PrevNotisCopyWith<$Res> {
  factory $PrevNotisCopyWith(PrevNotis value, $Res Function(PrevNotis) _then) =
      _$PrevNotisCopyWithImpl;
  @useResult
  $Res call(
      {String notificationId,
      String uid,
      bool isMeResponded,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$PrevNotisCopyWithImpl<$Res> implements $PrevNotisCopyWith<$Res> {
  _$PrevNotisCopyWithImpl(this._self, this._then);

  final PrevNotis _self;
  final $Res Function(PrevNotis) _then;

  /// Create a copy of PrevNotis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? uid = null,
    Object? isMeResponded = null,
    Object? createdAt = freezed,
  }) {
    return _then(_self.copyWith(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      isMeResponded: null == isMeResponded
          ? _self.isMeResponded
          : isMeResponded // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PrevNotis with DiagnosticableTreeMixin implements PrevNotis {
  const _PrevNotis(
      {this.notificationId = '',
      this.uid = '',
      this.isMeResponded = false,
      @TimestampConverter() this.createdAt});
  factory _PrevNotis.fromJson(Map<String, dynamic> json) =>
      _$PrevNotisFromJson(json);

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

  /// Create a copy of PrevNotis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PrevNotisCopyWith<_PrevNotis> get copyWith =>
      __$PrevNotisCopyWithImpl<_PrevNotis>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PrevNotisToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _PrevNotis &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.isMeResponded, isMeResponded) ||
                other.isMeResponded == isMeResponded) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notificationId, uid, isMeResponded, createdAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PrevNotis(notificationId: $notificationId, uid: $uid, isMeResponded: $isMeResponded, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PrevNotisCopyWith<$Res>
    implements $PrevNotisCopyWith<$Res> {
  factory _$PrevNotisCopyWith(
          _PrevNotis value, $Res Function(_PrevNotis) _then) =
      __$PrevNotisCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String uid,
      bool isMeResponded,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$PrevNotisCopyWithImpl<$Res> implements _$PrevNotisCopyWith<$Res> {
  __$PrevNotisCopyWithImpl(this._self, this._then);

  final _PrevNotis _self;
  final $Res Function(_PrevNotis) _then;

  /// Create a copy of PrevNotis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notificationId = null,
    Object? uid = null,
    Object? isMeResponded = null,
    Object? createdAt = freezed,
  }) {
    return _then(_PrevNotis(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      isMeResponded: null == isMeResponded
          ? _self.isMeResponded
          : isMeResponded // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
