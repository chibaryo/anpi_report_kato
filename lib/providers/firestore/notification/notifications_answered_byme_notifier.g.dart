// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_answered_byme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamNotificationAnswerByMeNotifierHash() =>
    r'b8a0be43cfc7d5fa60dfc1fdc64a57a1636bb972';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$StreamNotificationAnswerByMeNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Map<String, dynamic>>> {
  late final String uid;

  Stream<List<Map<String, dynamic>>> build(
    String uid,
  );
}

/// See also [StreamNotificationAnswerByMeNotifier].
@ProviderFor(StreamNotificationAnswerByMeNotifier)
const streamNotificationAnswerByMeNotifierProvider =
    StreamNotificationAnswerByMeNotifierFamily();

/// See also [StreamNotificationAnswerByMeNotifier].
class StreamNotificationAnswerByMeNotifierFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [StreamNotificationAnswerByMeNotifier].
  const StreamNotificationAnswerByMeNotifierFamily();

  /// See also [StreamNotificationAnswerByMeNotifier].
  StreamNotificationAnswerByMeNotifierProvider call(
    String uid,
  ) {
    return StreamNotificationAnswerByMeNotifierProvider(
      uid,
    );
  }

  @override
  StreamNotificationAnswerByMeNotifierProvider getProviderOverride(
    covariant StreamNotificationAnswerByMeNotifierProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streamNotificationAnswerByMeNotifierProvider';
}

/// See also [StreamNotificationAnswerByMeNotifier].
class StreamNotificationAnswerByMeNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<
        StreamNotificationAnswerByMeNotifier, List<Map<String, dynamic>>> {
  /// See also [StreamNotificationAnswerByMeNotifier].
  StreamNotificationAnswerByMeNotifierProvider(
    String uid,
  ) : this._internal(
          () => StreamNotificationAnswerByMeNotifier()..uid = uid,
          from: streamNotificationAnswerByMeNotifierProvider,
          name: r'streamNotificationAnswerByMeNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamNotificationAnswerByMeNotifierHash,
          dependencies:
              StreamNotificationAnswerByMeNotifierFamily._dependencies,
          allTransitiveDependencies: StreamNotificationAnswerByMeNotifierFamily
              ._allTransitiveDependencies,
          uid: uid,
        );

  StreamNotificationAnswerByMeNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Stream<List<Map<String, dynamic>>> runNotifierBuild(
    covariant StreamNotificationAnswerByMeNotifier notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(
      StreamNotificationAnswerByMeNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamNotificationAnswerByMeNotifierProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<StreamNotificationAnswerByMeNotifier,
      List<Map<String, dynamic>>> createElement() {
    return _StreamNotificationAnswerByMeNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamNotificationAnswerByMeNotifierProvider &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamNotificationAnswerByMeNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _StreamNotificationAnswerByMeNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        StreamNotificationAnswerByMeNotifier, List<Map<String, dynamic>>>
    with StreamNotificationAnswerByMeNotifierRef {
  _StreamNotificationAnswerByMeNotifierProviderElement(super.provider);

  @override
  String get uid =>
      (origin as StreamNotificationAnswerByMeNotifierProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
