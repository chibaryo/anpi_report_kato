// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'officelocation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfficeLocation implements DiagnosticableTreeMixin {
  String get displayName;
  int get sortNumber;
  bool get isActive;
  @TimestampConverter()
  DateTime? get createdAt;
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of OfficeLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OfficeLocationCopyWith<OfficeLocation> get copyWith =>
      _$OfficeLocationCopyWithImpl<OfficeLocation>(
          this as OfficeLocation, _$identity);

  /// Serializes this OfficeLocation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OfficeLocation'))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('sortNumber', sortNumber))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OfficeLocation &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.sortNumber, sortNumber) ||
                other.sortNumber == sortNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, displayName, sortNumber, isActive, createdAt, updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OfficeLocation(displayName: $displayName, sortNumber: $sortNumber, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OfficeLocationCopyWith<$Res> {
  factory $OfficeLocationCopyWith(
          OfficeLocation value, $Res Function(OfficeLocation) _then) =
      _$OfficeLocationCopyWithImpl;
  @useResult
  $Res call(
      {String displayName,
      int sortNumber,
      bool isActive,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$OfficeLocationCopyWithImpl<$Res>
    implements $OfficeLocationCopyWith<$Res> {
  _$OfficeLocationCopyWithImpl(this._self, this._then);

  final OfficeLocation _self;
  final $Res Function(OfficeLocation) _then;

  /// Create a copy of OfficeLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? sortNumber = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      sortNumber: null == sortNumber
          ? _self.sortNumber
          : sortNumber // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _OfficeLocation with DiagnosticableTreeMixin implements OfficeLocation {
  const _OfficeLocation(
      {this.displayName = '',
      this.sortNumber = 0,
      this.isActive = true,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});
  factory _OfficeLocation.fromJson(Map<String, dynamic> json) =>
      _$OfficeLocationFromJson(json);

  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final int sortNumber;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of OfficeLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OfficeLocationCopyWith<_OfficeLocation> get copyWith =>
      __$OfficeLocationCopyWithImpl<_OfficeLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OfficeLocationToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OfficeLocation'))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('sortNumber', sortNumber))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OfficeLocation &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.sortNumber, sortNumber) ||
                other.sortNumber == sortNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, displayName, sortNumber, isActive, createdAt, updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OfficeLocation(displayName: $displayName, sortNumber: $sortNumber, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OfficeLocationCopyWith<$Res>
    implements $OfficeLocationCopyWith<$Res> {
  factory _$OfficeLocationCopyWith(
          _OfficeLocation value, $Res Function(_OfficeLocation) _then) =
      __$OfficeLocationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String displayName,
      int sortNumber,
      bool isActive,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$OfficeLocationCopyWithImpl<$Res>
    implements _$OfficeLocationCopyWith<$Res> {
  __$OfficeLocationCopyWithImpl(this._self, this._then);

  final _OfficeLocation _self;
  final $Res Function(_OfficeLocation) _then;

  /// Create a copy of OfficeLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? displayName = null,
    Object? sortNumber = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_OfficeLocation(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      sortNumber: null == sortNumber
          ? _self.sortNumber
          : sortNumber // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
