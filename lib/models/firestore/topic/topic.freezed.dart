// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Topic implements DiagnosticableTreeMixin {
  String get displayName;
  String get topic;
  int get sortNumber;
  int get bitMaskNum;
  bool get isActive;
  @TimestampConverter()
  DateTime? get createdAt;
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopicCopyWith<Topic> get copyWith =>
      _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Topic'))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('topic', topic))
      ..add(DiagnosticsProperty('sortNumber', sortNumber))
      ..add(DiagnosticsProperty('bitMaskNum', bitMaskNum))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Topic &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.sortNumber, sortNumber) ||
                other.sortNumber == sortNumber) &&
            (identical(other.bitMaskNum, bitMaskNum) ||
                other.bitMaskNum == bitMaskNum) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, topic, sortNumber,
      bitMaskNum, isActive, createdAt, updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Topic(displayName: $displayName, topic: $topic, sortNumber: $sortNumber, bitMaskNum: $bitMaskNum, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) =
      _$TopicCopyWithImpl;
  @useResult
  $Res call(
      {String displayName,
      String topic,
      int sortNumber,
      int bitMaskNum,
      bool isActive,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$TopicCopyWithImpl<$Res> implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? topic = null,
    Object? sortNumber = null,
    Object? bitMaskNum = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      sortNumber: null == sortNumber
          ? _self.sortNumber
          : sortNumber // ignore: cast_nullable_to_non_nullable
              as int,
      bitMaskNum: null == bitMaskNum
          ? _self.bitMaskNum
          : bitMaskNum // ignore: cast_nullable_to_non_nullable
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
class _Topic with DiagnosticableTreeMixin implements Topic {
  const _Topic(
      {this.displayName = '',
      this.topic = '',
      this.sortNumber = 0,
      this.bitMaskNum = 0,
      this.isActive = true,
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt});
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String topic;
  @override
  @JsonKey()
  final int sortNumber;
  @override
  @JsonKey()
  final int bitMaskNum;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopicCopyWith<_Topic> get copyWith =>
      __$TopicCopyWithImpl<_Topic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopicToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'Topic'))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('topic', topic))
      ..add(DiagnosticsProperty('sortNumber', sortNumber))
      ..add(DiagnosticsProperty('bitMaskNum', bitMaskNum))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Topic &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.sortNumber, sortNumber) ||
                other.sortNumber == sortNumber) &&
            (identical(other.bitMaskNum, bitMaskNum) ||
                other.bitMaskNum == bitMaskNum) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, topic, sortNumber,
      bitMaskNum, isActive, createdAt, updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Topic(displayName: $displayName, topic: $topic, sortNumber: $sortNumber, bitMaskNum: $bitMaskNum, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) =
      __$TopicCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String displayName,
      String topic,
      int sortNumber,
      int bitMaskNum,
      bool isActive,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$TopicCopyWithImpl<$Res> implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? displayName = null,
    Object? topic = null,
    Object? sortNumber = null,
    Object? bitMaskNum = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_Topic(
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      sortNumber: null == sortNumber
          ? _self.sortNumber
          : sortNumber // ignore: cast_nullable_to_non_nullable
              as int,
      bitMaskNum: null == bitMaskNum
          ? _self.bitMaskNum
          : bitMaskNum // ignore: cast_nullable_to_non_nullable
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
