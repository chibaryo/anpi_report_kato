// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'userreport.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserReport _$UserReportFromJson(Map<String, dynamic> json) {
  return _UserReport.fromJson(json);
}

/// @nodoc
mixin _$UserReport {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get siteCode => throw _privateConstructorUsedError;
  String get anpiStatus => throw _privateConstructorUsedError;
  String get gotoOfficeStatus => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get isLocationPermitted => throw _privateConstructorUsedError;
  List<String> get position =>
      throw _privateConstructorUsedError; // latitude, longitude, altitude
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReportCopyWith<UserReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReportCopyWith<$Res> {
  factory $UserReportCopyWith(
          UserReport value, $Res Function(UserReport) then) =
      _$UserReportCopyWithImpl<$Res, UserReport>;
  @useResult
  $Res call(
      {String uid,
      String name,
      int siteCode,
      String anpiStatus,
      String gotoOfficeStatus,
      String message,
      bool isLocationPermitted,
      List<String> position,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$UserReportCopyWithImpl<$Res, $Val extends UserReport>
    implements $UserReportCopyWith<$Res> {
  _$UserReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? siteCode = null,
    Object? anpiStatus = null,
    Object? gotoOfficeStatus = null,
    Object? message = null,
    Object? isLocationPermitted = null,
    Object? position = null,
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
      siteCode: null == siteCode
          ? _value.siteCode
          : siteCode // ignore: cast_nullable_to_non_nullable
              as int,
      anpiStatus: null == anpiStatus
          ? _value.anpiStatus
          : anpiStatus // ignore: cast_nullable_to_non_nullable
              as String,
      gotoOfficeStatus: null == gotoOfficeStatus
          ? _value.gotoOfficeStatus
          : gotoOfficeStatus // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isLocationPermitted: null == isLocationPermitted
          ? _value.isLocationPermitted
          : isLocationPermitted // ignore: cast_nullable_to_non_nullable
              as bool,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserReportImplCopyWith<$Res>
    implements $UserReportCopyWith<$Res> {
  factory _$$UserReportImplCopyWith(
          _$UserReportImpl value, $Res Function(_$UserReportImpl) then) =
      __$$UserReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      int siteCode,
      String anpiStatus,
      String gotoOfficeStatus,
      String message,
      bool isLocationPermitted,
      List<String> position,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$$UserReportImplCopyWithImpl<$Res>
    extends _$UserReportCopyWithImpl<$Res, _$UserReportImpl>
    implements _$$UserReportImplCopyWith<$Res> {
  __$$UserReportImplCopyWithImpl(
      _$UserReportImpl _value, $Res Function(_$UserReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? siteCode = null,
    Object? anpiStatus = null,
    Object? gotoOfficeStatus = null,
    Object? message = null,
    Object? isLocationPermitted = null,
    Object? position = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserReportImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      siteCode: null == siteCode
          ? _value.siteCode
          : siteCode // ignore: cast_nullable_to_non_nullable
              as int,
      anpiStatus: null == anpiStatus
          ? _value.anpiStatus
          : anpiStatus // ignore: cast_nullable_to_non_nullable
              as String,
      gotoOfficeStatus: null == gotoOfficeStatus
          ? _value.gotoOfficeStatus
          : gotoOfficeStatus // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isLocationPermitted: null == isLocationPermitted
          ? _value.isLocationPermitted
          : isLocationPermitted // ignore: cast_nullable_to_non_nullable
              as bool,
      position: null == position
          ? _value._position
          : position // ignore: cast_nullable_to_non_nullable
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
class _$UserReportImpl with DiagnosticableTreeMixin implements _UserReport {
  const _$UserReportImpl(
      {this.uid = '',
      this.name = '',
      this.siteCode = 0,
      this.anpiStatus = '',
      this.gotoOfficeStatus = '',
      this.message = '',
      this.isLocationPermitted = false,
      final List<String> position = const [],
      @TimestampConverter() this.createdAt})
      : _position = position;

  factory _$UserReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReportImplFromJson(json);

  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int siteCode;
  @override
  @JsonKey()
  final String anpiStatus;
  @override
  @JsonKey()
  final String gotoOfficeStatus;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final bool isLocationPermitted;
  final List<String> _position;
  @override
  @JsonKey()
  List<String> get position {
    if (_position is EqualUnmodifiableListView) return _position;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_position);
  }

// latitude, longitude, altitude
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserReport(uid: $uid, name: $name, siteCode: $siteCode, anpiStatus: $anpiStatus, gotoOfficeStatus: $gotoOfficeStatus, message: $message, isLocationPermitted: $isLocationPermitted, position: $position, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserReport'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('siteCode', siteCode))
      ..add(DiagnosticsProperty('anpiStatus', anpiStatus))
      ..add(DiagnosticsProperty('gotoOfficeStatus', gotoOfficeStatus))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('isLocationPermitted', isLocationPermitted))
      ..add(DiagnosticsProperty('position', position))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReportImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.siteCode, siteCode) ||
                other.siteCode == siteCode) &&
            (identical(other.anpiStatus, anpiStatus) ||
                other.anpiStatus == anpiStatus) &&
            (identical(other.gotoOfficeStatus, gotoOfficeStatus) ||
                other.gotoOfficeStatus == gotoOfficeStatus) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isLocationPermitted, isLocationPermitted) ||
                other.isLocationPermitted == isLocationPermitted) &&
            const DeepCollectionEquality().equals(other._position, _position) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      name,
      siteCode,
      anpiStatus,
      gotoOfficeStatus,
      message,
      isLocationPermitted,
      const DeepCollectionEquality().hash(_position),
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReportImplCopyWith<_$UserReportImpl> get copyWith =>
      __$$UserReportImplCopyWithImpl<_$UserReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReportImplToJson(
      this,
    );
  }
}

abstract class _UserReport implements UserReport {
  const factory _UserReport(
      {final String uid,
      final String name,
      final int siteCode,
      final String anpiStatus,
      final String gotoOfficeStatus,
      final String message,
      final bool isLocationPermitted,
      final List<String> position,
      @TimestampConverter() final DateTime? createdAt}) = _$UserReportImpl;

  factory _UserReport.fromJson(Map<String, dynamic> json) =
      _$UserReportImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  int get siteCode;
  @override
  String get anpiStatus;
  @override
  String get gotoOfficeStatus;
  @override
  String get message;
  @override
  bool get isLocationPermitted;
  @override
  List<String> get position;
  @override // latitude, longitude, altitude
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserReportImplCopyWith<_$UserReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
