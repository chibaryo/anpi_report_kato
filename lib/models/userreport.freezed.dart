// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'userreport.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserReport {
  String get uid;
  String get notificationId;
  @DocumentReferenceConverter()
  DocumentReference get userRef;
  @DocumentReferenceConverter()
  DocumentReference get profileRef;
  Map<String, dynamic> get reportContents;
  @TimestampConverter()
  DateTime? get createdAt;
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of UserReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserReportCopyWith<UserReport> get copyWith =>
      _$UserReportCopyWithImpl<UserReport>(this as UserReport, _$identity);

  /// Serializes this UserReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserReport &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.userRef, userRef) || other.userRef == userRef) &&
            (identical(other.profileRef, profileRef) ||
                other.profileRef == profileRef) &&
            const DeepCollectionEquality()
                .equals(other.reportContents, reportContents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      notificationId,
      userRef,
      profileRef,
      const DeepCollectionEquality().hash(reportContents),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserReport(uid: $uid, notificationId: $notificationId, userRef: $userRef, profileRef: $profileRef, reportContents: $reportContents, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserReportCopyWith<$Res> {
  factory $UserReportCopyWith(
          UserReport value, $Res Function(UserReport) _then) =
      _$UserReportCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String notificationId,
      @DocumentReferenceConverter() DocumentReference<Object?> userRef,
      @DocumentReferenceConverter() DocumentReference<Object?> profileRef,
      Map<String, dynamic> reportContents,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$UserReportCopyWithImpl<$Res> implements $UserReportCopyWith<$Res> {
  _$UserReportCopyWithImpl(this._self, this._then);

  final UserReport _self;
  final $Res Function(UserReport) _then;

  /// Create a copy of UserReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? notificationId = null,
    Object? userRef = null,
    Object? profileRef = null,
    Object? reportContents = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      userRef: null == userRef
          ? _self.userRef!
          : userRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      profileRef: null == profileRef
          ? _self.profileRef!
          : profileRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      reportContents: null == reportContents
          ? _self.reportContents
          : reportContents // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
class _UserReport implements UserReport {
  const _UserReport(
      {this.uid = '',
      this.notificationId = '',
      @DocumentReferenceConverter() required this.userRef,
      @DocumentReferenceConverter() required this.profileRef,
      final Map<String, dynamic> reportContents = const <String, dynamic>{},
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt})
      : _reportContents = reportContents;
  factory _UserReport.fromJson(Map<String, dynamic> json) =>
      _$UserReportFromJson(json);

  @override
  @JsonKey()
  final String uid;
  @override
  @JsonKey()
  final String notificationId;
  @override
  @DocumentReferenceConverter()
  final DocumentReference<Object?> userRef;
  @override
  @DocumentReferenceConverter()
  final DocumentReference<Object?> profileRef;
  final Map<String, dynamic> _reportContents;
  @override
  @JsonKey()
  Map<String, dynamic> get reportContents {
    if (_reportContents is EqualUnmodifiableMapView) return _reportContents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reportContents);
  }

  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of UserReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserReportCopyWith<_UserReport> get copyWith =>
      __$UserReportCopyWithImpl<_UserReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserReportToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserReport &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.userRef, userRef) || other.userRef == userRef) &&
            (identical(other.profileRef, profileRef) ||
                other.profileRef == profileRef) &&
            const DeepCollectionEquality()
                .equals(other._reportContents, _reportContents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      notificationId,
      userRef,
      profileRef,
      const DeepCollectionEquality().hash(_reportContents),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'UserReport(uid: $uid, notificationId: $notificationId, userRef: $userRef, profileRef: $profileRef, reportContents: $reportContents, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserReportCopyWith<$Res>
    implements $UserReportCopyWith<$Res> {
  factory _$UserReportCopyWith(
          _UserReport value, $Res Function(_UserReport) _then) =
      __$UserReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String notificationId,
      @DocumentReferenceConverter() DocumentReference<Object?> userRef,
      @DocumentReferenceConverter() DocumentReference<Object?> profileRef,
      Map<String, dynamic> reportContents,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$UserReportCopyWithImpl<$Res> implements _$UserReportCopyWith<$Res> {
  __$UserReportCopyWithImpl(this._self, this._then);

  final _UserReport _self;
  final $Res Function(_UserReport) _then;

  /// Create a copy of UserReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? notificationId = null,
    Object? userRef = null,
    Object? profileRef = null,
    Object? reportContents = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserReport(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _self.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      userRef: null == userRef
          ? _self.userRef
          : userRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      profileRef: null == profileRef
          ? _self.profileRef
          : profileRef // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      reportContents: null == reportContents
          ? _self._reportContents
          : reportContents // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
