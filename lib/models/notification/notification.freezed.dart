// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Noti _$NotiFromJson(Map<String, dynamic> json) {
  return _Noti.fromJson(json);
}

/// @nodoc
mixin _$Noti {
  String get notificationId => throw _privateConstructorUsedError;
  String get notiTitle => throw _privateConstructorUsedError;
  String get notiBody => throw _privateConstructorUsedError;
  int get notiType => throw _privateConstructorUsedError;
  String get notiTopic => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Noti to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotiCopyWith<Noti> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotiCopyWith<$Res> {
  factory $NotiCopyWith(Noti value, $Res Function(Noti) then) =
      _$NotiCopyWithImpl<$Res, Noti>;
  @useResult
  $Res call(
      {String notificationId,
      String notiTitle,
      String notiBody,
      int notiType,
      String notiTopic,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$NotiCopyWithImpl<$Res, $Val extends Noti>
    implements $NotiCopyWith<$Res> {
  _$NotiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? notiType = null,
    Object? notiTopic = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _value.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _value.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      notiType: null == notiType
          ? _value.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int,
      notiTopic: null == notiTopic
          ? _value.notiTopic
          : notiTopic // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotiImplCopyWith<$Res> implements $NotiCopyWith<$Res> {
  factory _$$NotiImplCopyWith(
          _$NotiImpl value, $Res Function(_$NotiImpl) then) =
      __$$NotiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String notiTitle,
      String notiBody,
      int notiType,
      String notiTopic,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$$NotiImplCopyWithImpl<$Res>
    extends _$NotiCopyWithImpl<$Res, _$NotiImpl>
    implements _$$NotiImplCopyWith<$Res> {
  __$$NotiImplCopyWithImpl(_$NotiImpl _value, $Res Function(_$NotiImpl) _then)
      : super(_value, _then);

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? notiType = null,
    Object? notiTopic = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NotiImpl(
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _value.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _value.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      notiType: null == notiType
          ? _value.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int,
      notiTopic: null == notiTopic
          ? _value.notiTopic
          : notiTopic // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotiImpl with DiagnosticableTreeMixin implements _Noti {
  const _$NotiImpl(
      {this.notificationId = '',
      this.notiTitle = '',
      this.notiBody = '',
      this.notiType = 0,
      this.notiTopic = '',
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});

  factory _$NotiImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotiImplFromJson(json);

  @override
  @JsonKey()
  final String notificationId;
  @override
  @JsonKey()
  final String notiTitle;
  @override
  @JsonKey()
  final String notiBody;
  @override
  @JsonKey()
  final int notiType;
  @override
  @JsonKey()
  final String notiTopic;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Noti(notificationId: $notificationId, notiTitle: $notiTitle, notiBody: $notiBody, notiType: $notiType, notiTopic: $notiTopic, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Noti'))
      ..add(DiagnosticsProperty('notificationId', notificationId))
      ..add(DiagnosticsProperty('notiTitle', notiTitle))
      ..add(DiagnosticsProperty('notiBody', notiBody))
      ..add(DiagnosticsProperty('notiType', notiType))
      ..add(DiagnosticsProperty('notiTopic', notiTopic))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotiImpl &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.notiTitle, notiTitle) ||
                other.notiTitle == notiTitle) &&
            (identical(other.notiBody, notiBody) ||
                other.notiBody == notiBody) &&
            (identical(other.notiType, notiType) ||
                other.notiType == notiType) &&
            (identical(other.notiTopic, notiTopic) ||
                other.notiTopic == notiTopic) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, notificationId, notiTitle,
      notiBody, notiType, notiTopic, createdAt, updatedAt);

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotiImplCopyWith<_$NotiImpl> get copyWith =>
      __$$NotiImplCopyWithImpl<_$NotiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotiImplToJson(
      this,
    );
  }
}

abstract class _Noti implements Noti {
  const factory _Noti(
      {final String notificationId,
      final String notiTitle,
      final String notiBody,
      final int notiType,
      final String notiTopic,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? updatedAt}) = _$NotiImpl;

  factory _Noti.fromJson(Map<String, dynamic> json) = _$NotiImpl.fromJson;

  @override
  String get notificationId;
  @override
  String get notiTitle;
  @override
  String get notiBody;
  @override
  int get notiType;
  @override
  String get notiTopic;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotiImplCopyWith<_$NotiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
