// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Noti implements DiagnosticableTreeMixin {
  String get notificationId;
  String get notiTitle;
  String get notiBody;
  int get notiType;
  String get notiTopic;
  @TimestampConverter()
  DateTime? get createdAt;
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotiCopyWith<Noti> get copyWith =>
      _$NotiCopyWithImpl<Noti>(this as Noti, _$identity);

  /// Serializes this Noti to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is Noti &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Noti(notificationId: $notificationId, notiTitle: $notiTitle, notiBody: $notiBody, notiType: $notiType, notiTopic: $notiTopic, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $NotiCopyWith<$Res> {
  factory $NotiCopyWith(Noti value, $Res Function(Noti) _then) =
      _$NotiCopyWithImpl;
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
class _$NotiCopyWithImpl<$Res> implements $NotiCopyWith<$Res> {
  _$NotiCopyWithImpl(this._self, this._then);

  final Noti _self;
  final $Res Function(Noti) _then;

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
    return _then(_self.copyWith(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _self.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _self.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      notiType: null == notiType
          ? _self.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int,
      notiTopic: null == notiTopic
          ? _self.notiTopic
          : notiTopic // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Noti with DiagnosticableTreeMixin implements Noti {
  const _Noti(
      {this.notificationId = '',
      this.notiTitle = '',
      this.notiBody = '',
      this.notiType = 0,
      this.notiTopic = '',
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});
  factory _Noti.fromJson(Map<String, dynamic> json) => _$NotiFromJson(json);

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

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotiCopyWith<_Noti> get copyWith =>
      __$NotiCopyWithImpl<_Noti>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotiToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _Noti &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Noti(notificationId: $notificationId, notiTitle: $notiTitle, notiBody: $notiBody, notiType: $notiType, notiTopic: $notiTopic, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$NotiCopyWith<$Res> implements $NotiCopyWith<$Res> {
  factory _$NotiCopyWith(_Noti value, $Res Function(_Noti) _then) =
      __$NotiCopyWithImpl;
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
class __$NotiCopyWithImpl<$Res> implements _$NotiCopyWith<$Res> {
  __$NotiCopyWithImpl(this._self, this._then);

  final _Noti _self;
  final $Res Function(_Noti) _then;

  /// Create a copy of Noti
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? notificationId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? notiType = null,
    Object? notiTopic = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_Noti(
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _self.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _self.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      notiType: null == notiType
          ? _self.notiType
          : notiType // ignore: cast_nullable_to_non_nullable
              as int,
      notiTopic: null == notiTopic
          ? _self.notiTopic
          : notiTopic // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
