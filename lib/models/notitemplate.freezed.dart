// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notitemplate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotiTemplate _$NotiTemplateFromJson(Map<String, dynamic> json) {
  return _NotiTemplate.fromJson(json);
}

/// @nodoc
mixin _$NotiTemplate {
  String get notiTemplateId => throw _privateConstructorUsedError;
  String get notiTitle => throw _privateConstructorUsedError;
  String get notiBody => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotiTemplateCopyWith<NotiTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotiTemplateCopyWith<$Res> {
  factory $NotiTemplateCopyWith(
          NotiTemplate value, $Res Function(NotiTemplate) then) =
      _$NotiTemplateCopyWithImpl<$Res, NotiTemplate>;
  @useResult
  $Res call(
      {String notiTemplateId,
      String notiTitle,
      String notiBody,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class _$NotiTemplateCopyWithImpl<$Res, $Val extends NotiTemplate>
    implements $NotiTemplateCopyWith<$Res> {
  _$NotiTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notiTemplateId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      notiTemplateId: null == notiTemplateId
          ? _value.notiTemplateId
          : notiTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _value.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _value.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotiTemplateImplCopyWith<$Res>
    implements $NotiTemplateCopyWith<$Res> {
  factory _$$NotiTemplateImplCopyWith(
          _$NotiTemplateImpl value, $Res Function(_$NotiTemplateImpl) then) =
      __$$NotiTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String notiTemplateId,
      String notiTitle,
      String notiBody,
      @TimestampConverter() DateTime? createdAt});
}

/// @nodoc
class __$$NotiTemplateImplCopyWithImpl<$Res>
    extends _$NotiTemplateCopyWithImpl<$Res, _$NotiTemplateImpl>
    implements _$$NotiTemplateImplCopyWith<$Res> {
  __$$NotiTemplateImplCopyWithImpl(
      _$NotiTemplateImpl _value, $Res Function(_$NotiTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notiTemplateId = null,
    Object? notiTitle = null,
    Object? notiBody = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$NotiTemplateImpl(
      notiTemplateId: null == notiTemplateId
          ? _value.notiTemplateId
          : notiTemplateId // ignore: cast_nullable_to_non_nullable
              as String,
      notiTitle: null == notiTitle
          ? _value.notiTitle
          : notiTitle // ignore: cast_nullable_to_non_nullable
              as String,
      notiBody: null == notiBody
          ? _value.notiBody
          : notiBody // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotiTemplateImpl with DiagnosticableTreeMixin implements _NotiTemplate {
  const _$NotiTemplateImpl(
      {this.notiTemplateId = '',
      this.notiTitle = '',
      this.notiBody = '',
      @TimestampConverter() this.createdAt});

  factory _$NotiTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotiTemplateImplFromJson(json);

  @override
  @JsonKey()
  final String notiTemplateId;
  @override
  @JsonKey()
  final String notiTitle;
  @override
  @JsonKey()
  final String notiBody;
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NotiTemplate(notiTemplateId: $notiTemplateId, notiTitle: $notiTitle, notiBody: $notiBody, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NotiTemplate'))
      ..add(DiagnosticsProperty('notiTemplateId', notiTemplateId))
      ..add(DiagnosticsProperty('notiTitle', notiTitle))
      ..add(DiagnosticsProperty('notiBody', notiBody))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotiTemplateImpl &&
            (identical(other.notiTemplateId, notiTemplateId) ||
                other.notiTemplateId == notiTemplateId) &&
            (identical(other.notiTitle, notiTitle) ||
                other.notiTitle == notiTitle) &&
            (identical(other.notiBody, notiBody) ||
                other.notiBody == notiBody) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, notiTemplateId, notiTitle, notiBody, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotiTemplateImplCopyWith<_$NotiTemplateImpl> get copyWith =>
      __$$NotiTemplateImplCopyWithImpl<_$NotiTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotiTemplateImplToJson(
      this,
    );
  }
}

abstract class _NotiTemplate implements NotiTemplate {
  const factory _NotiTemplate(
      {final String notiTemplateId,
      final String notiTitle,
      final String notiBody,
      @TimestampConverter() final DateTime? createdAt}) = _$NotiTemplateImpl;

  factory _NotiTemplate.fromJson(Map<String, dynamic> json) =
      _$NotiTemplateImpl.fromJson;

  @override
  String get notiTemplateId;
  @override
  String get notiTitle;
  @override
  String get notiBody;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$NotiTemplateImplCopyWith<_$NotiTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
