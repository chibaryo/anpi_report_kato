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

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return _Notification.fromJson(json);
}

/// @nodoc
mixin _$Notification {
  String get notificationId => throw _privateConstructorUsedError;
  String get notiTitle => throw _privateConstructorUsedError;
  String get notiBody => throw _privateConstructorUsedError;
  List<String> get a_respondents => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationCopyWith<Notification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationCopyWith<$Res> {
  factory $NotificationCopyWith(
          Notification value, $Res Function(Notification) then) =
      _$NotificationCopyWithImpl<$Res, Notification>;
  @useResult
  $Res call(
      {String notificationId,
      String notiTitle,
      String notiBody,
      List<String> a_respondents,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$NotificationCopyWithImpl<$Res, $Val extends Notification>
    implements $NotificationCopyWith<$Res> {
  _$NotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? a_respondents = null,
    Object? createdAt = freezed,
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
      a_respondents: null == a_respondents
          ? _value.a_respondents
          : a_respondents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationImplCopyWith<$Res>
    implements $NotificationCopyWith<$Res> {
  factory _$$NotificationImplCopyWith(
          _$NotificationImpl value, $Res Function(_$NotificationImpl) then) =
      __$$NotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String notificationId,
      String notiTitle,
      String notiBody,
      List<String> a_respondents,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$$NotificationImplCopyWithImpl<$Res>
    extends _$NotificationCopyWithImpl<$Res, _$NotificationImpl>
    implements _$$NotificationImplCopyWith<$Res> {
  __$$NotificationImplCopyWithImpl(
      _$NotificationImpl _value, $Res Function(_$NotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? a_respondents = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$NotificationImpl(
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
      a_respondents: null == a_respondents
          ? _value._a_respondents
          : a_respondents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationImpl with DiagnosticableTreeMixin implements _Notification {
  const _$NotificationImpl(
      {this.notificationId = '',
      this.notiTitle = '',
      this.notiBody = '',
      final List<String> a_respondents = const [],
      @TimestampConverter() this.createdAt})
      : _a_respondents = a_respondents;

  factory _$NotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationImplFromJson(json);

  @override
  @JsonKey()
  final String notificationId;
  @override
  @JsonKey()
  final String notiTitle;
  @override
  @JsonKey()
  final String notiBody;
  final List<String> _a_respondents;
  @override
  @JsonKey()
  List<String> get a_respondents {
    if (_a_respondents is EqualUnmodifiableListView) return _a_respondents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_a_respondents);
  }

  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Notification(notificationId: $notificationId, notiTitle: $notiTitle, notiBody: $notiBody, a_respondents: $a_respondents, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Notification'))
      ..add(DiagnosticsProperty('notificationId', notificationId))
      ..add(DiagnosticsProperty('notiTitle', notiTitle))
      ..add(DiagnosticsProperty('notiBody', notiBody))
      ..add(DiagnosticsProperty('a_respondents', a_respondents))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationImpl &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.notiTitle, notiTitle) ||
                other.notiTitle == notiTitle) &&
            (identical(other.notiBody, notiBody) ||
                other.notiBody == notiBody) &&
            const DeepCollectionEquality()
                .equals(other._a_respondents, _a_respondents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, notificationId, notiTitle,
      notiBody, const DeepCollectionEquality().hash(_a_respondents), createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationImplCopyWith<_$NotificationImpl> get copyWith =>
      __$$NotificationImplCopyWithImpl<_$NotificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationImplToJson(
      this,
    );
  }
}

abstract class _Notification implements Notification {
  const factory _Notification(
      {final String notificationId,
      final String notiTitle,
      final String notiBody,
      final List<String> a_respondents,
      @TimestampConverter() final DateTime? createdAt}) = _$NotificationImpl;

  factory _Notification.fromJson(Map<String, dynamic> json) =
      _$NotificationImpl.fromJson;

  @override
  String get notificationId;
  @override
  String get notiTitle;
  @override
  String get notiBody;
  @override
  List<String> get a_respondents;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotificationImplCopyWith<_$NotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
