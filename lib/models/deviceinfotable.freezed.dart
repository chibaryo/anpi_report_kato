// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deviceinfotable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceInfoTable implements DiagnosticableTreeMixin {
  String get systemName;
  String get osVersion;
  String get localizedModel;
  String get productName;
  String get udId;
  String get fcmToken;
  @TimestampConverter()
  DateTime? get createdAt;
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceInfoTableCopyWith<DeviceInfoTable> get copyWith =>
      _$DeviceInfoTableCopyWithImpl<DeviceInfoTable>(
          this as DeviceInfoTable, _$identity);

  /// Serializes this DeviceInfoTable to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is DeviceInfoTable &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DeviceInfoTable(systemName: $systemName, osVersion: $osVersion, localizedModel: $localizedModel, productName: $productName, udId: $udId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $DeviceInfoTableCopyWith<$Res> {
  factory $DeviceInfoTableCopyWith(
          DeviceInfoTable value, $Res Function(DeviceInfoTable) _then) =
      _$DeviceInfoTableCopyWithImpl;
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
class _$DeviceInfoTableCopyWithImpl<$Res>
    implements $DeviceInfoTableCopyWith<$Res> {
  _$DeviceInfoTableCopyWithImpl(this._self, this._then);

  final DeviceInfoTable _self;
  final $Res Function(DeviceInfoTable) _then;

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
    return _then(_self.copyWith(
      systemName: null == systemName
          ? _self.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _self.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      localizedModel: null == localizedModel
          ? _self.localizedModel
          : localizedModel // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      udId: null == udId
          ? _self.udId
          : udId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _self.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
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
class _DeviceInfoTable with DiagnosticableTreeMixin implements DeviceInfoTable {
  const _DeviceInfoTable(
      {this.systemName = '',
      this.osVersion = '',
      this.localizedModel = '',
      this.productName = '',
      this.udId = '',
      this.fcmToken = '',
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});
  factory _DeviceInfoTable.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoTableFromJson(json);

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

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceInfoTableCopyWith<_DeviceInfoTable> get copyWith =>
      __$DeviceInfoTableCopyWithImpl<_DeviceInfoTable>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeviceInfoTableToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _DeviceInfoTable &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DeviceInfoTable(systemName: $systemName, osVersion: $osVersion, localizedModel: $localizedModel, productName: $productName, udId: $udId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$DeviceInfoTableCopyWith<$Res>
    implements $DeviceInfoTableCopyWith<$Res> {
  factory _$DeviceInfoTableCopyWith(
          _DeviceInfoTable value, $Res Function(_DeviceInfoTable) _then) =
      __$DeviceInfoTableCopyWithImpl;
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
class __$DeviceInfoTableCopyWithImpl<$Res>
    implements _$DeviceInfoTableCopyWith<$Res> {
  __$DeviceInfoTableCopyWithImpl(this._self, this._then);

  final _DeviceInfoTable _self;
  final $Res Function(_DeviceInfoTable) _then;

  /// Create a copy of DeviceInfoTable
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_DeviceInfoTable(
      systemName: null == systemName
          ? _self.systemName
          : systemName // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _self.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      localizedModel: null == localizedModel
          ? _self.localizedModel
          : localizedModel // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      udId: null == udId
          ? _self.udId
          : udId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _self.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
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
