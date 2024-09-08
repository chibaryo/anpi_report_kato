// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deviceinfotable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DeviceInfoTable _$DeviceInfoTableFromJson(Map<String, dynamic> json) {
  return _DeviceInfoTable.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfoTable {
  String get systemName => throw _privateConstructorUsedError;
  String get osVersion => throw _privateConstructorUsedError;
  String get localizedModel => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get udId => throw _privateConstructorUsedError;
  String get fcmToken => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfoTable to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoTableCopyWith<DeviceInfoTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoTableCopyWith<$Res> {
  factory $DeviceInfoTableCopyWith(
          DeviceInfoTable value, $Res Function(DeviceInfoTable) then) =
      _$DeviceInfoTableCopyWithImpl<$Res, DeviceInfoTable>;
  @useResult
  $Res call(
      {String systemName,
      String osVersion,
      String localizedModel,
      String productName,
      String udId,
      String fcmToken,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$DeviceInfoTableCopyWithImpl<$Res, $Val extends DeviceInfoTable>
    implements $DeviceInfoTableCopyWith<$Res> {
  _$DeviceInfoTableCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = null,
    Object? osVersion = null,
    Object? localizedModel = null,
    Object? productName = null,
    Object? udId = null,
    Object? fcmToken = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      systemName: null == systemName
          ? _value.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      localizedModel: null == localizedModel
          ? _value.localizedModel
          : localizedModel // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      udId: null == udId
          ? _value.udId
          : udId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DeviceInfoTableImplCopyWith<$Res>
    implements $DeviceInfoTableCopyWith<$Res> {
  factory _$$DeviceInfoTableImplCopyWith(_$DeviceInfoTableImpl value,
          $Res Function(_$DeviceInfoTableImpl) then) =
      __$$DeviceInfoTableImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String systemName,
      String osVersion,
      String localizedModel,
      String productName,
      String udId,
      String fcmToken,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$$DeviceInfoTableImplCopyWithImpl<$Res>
    extends _$DeviceInfoTableCopyWithImpl<$Res, _$DeviceInfoTableImpl>
    implements _$$DeviceInfoTableImplCopyWith<$Res> {
  __$$DeviceInfoTableImplCopyWithImpl(
      _$DeviceInfoTableImpl _value, $Res Function(_$DeviceInfoTableImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = null,
    Object? osVersion = null,
    Object? localizedModel = null,
    Object? productName = null,
    Object? udId = null,
    Object? fcmToken = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DeviceInfoTableImpl(
      systemName: null == systemName
          ? _value.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      localizedModel: null == localizedModel
          ? _value.localizedModel
          : localizedModel // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      udId: null == udId
          ? _value.udId
          : udId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
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
class _$DeviceInfoTableImpl
    with DiagnosticableTreeMixin
    implements _DeviceInfoTable {
  const _$DeviceInfoTableImpl(
      {this.systemName = '',
      this.osVersion = '',
      this.localizedModel = '',
      this.productName = '',
      this.udId = '',
      this.fcmToken = '',
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});

  factory _$DeviceInfoTableImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoTableImplFromJson(json);

  @override
  @JsonKey()
  final String systemName;
  @override
  @JsonKey()
  final String osVersion;
  @override
  @JsonKey()
  final String localizedModel;
  @override
  @JsonKey()
  final String productName;
  @override
  @JsonKey()
  final String udId;
  @override
  @JsonKey()
  final String fcmToken;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DeviceInfoTable(systemName: $systemName, osVersion: $osVersion, localizedModel: $localizedModel, productName: $productName, udId: $udId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DeviceInfoTable'))
      ..add(DiagnosticsProperty('systemName', systemName))
      ..add(DiagnosticsProperty('osVersion', osVersion))
      ..add(DiagnosticsProperty('localizedModel', localizedModel))
      ..add(DiagnosticsProperty('productName', productName))
      ..add(DiagnosticsProperty('udId', udId))
      ..add(DiagnosticsProperty('fcmToken', fcmToken))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoTableImpl &&
            (identical(other.systemName, systemName) ||
                other.systemName == systemName) &&
            (identical(other.osVersion, osVersion) ||
                other.osVersion == osVersion) &&
            (identical(other.localizedModel, localizedModel) ||
                other.localizedModel == localizedModel) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.udId, udId) || other.udId == udId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, systemName, osVersion,
      localizedModel, productName, udId, fcmToken, createdAt, updatedAt);

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoTableImplCopyWith<_$DeviceInfoTableImpl> get copyWith =>
      __$$DeviceInfoTableImplCopyWithImpl<_$DeviceInfoTableImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoTableImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfoTable implements DeviceInfoTable {
  const factory _DeviceInfoTable(
      {final String systemName,
      final String osVersion,
      final String localizedModel,
      final String productName,
      final String udId,
      final String fcmToken,
      @TimestampConverter() final DateTime? createdAt,
      @TimestampConverter() final DateTime? updatedAt}) = _$DeviceInfoTableImpl;

  factory _DeviceInfoTable.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoTableImpl.fromJson;

  @override
  String get systemName;
  @override
  String get osVersion;
  @override
  String get localizedModel;
  @override
  String get productName;
  @override
  String get udId;
  @override
  String get fcmToken;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoTableImplCopyWith<_$DeviceInfoTableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
