// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combined_notification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamNotificationCombinedNotifierHash() =>
    r'aadb46d72880851da2213c5ec66f49a850044621';

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

abstract class _$StreamNotificationCombinedNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Map<String, dynamic>>> {
  late final String uid;

  Stream<List<Map<String, dynamic>>> build(
    String uid,
  );
}

/// See also [StreamNotificationCombinedNotifier].
@ProviderFor(StreamNotificationCombinedNotifier)
const streamNotificationCombinedNotifierProvider =
    StreamNotificationCombinedNotifierFamily();

/// See also [StreamNotificationCombinedNotifier].
class StreamNotificationCombinedNotifierFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [StreamNotificationCombinedNotifier].
  const StreamNotificationCombinedNotifierFamily();

  /// See also [StreamNotificationCombinedNotifier].
  StreamNotificationCombinedNotifierProvider call(
    String uid,
  ) {
    return StreamNotificationCombinedNotifierProvider(
      uid,
    );
  }

  @override
  StreamNotificationCombinedNotifierProvider getProviderOverride(
    covariant StreamNotificationCombinedNotifierProvider provider,
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
  String? get name => r'streamNotificationCombinedNotifierProvider';
}

/// See also [StreamNotificationCombinedNotifier].
class StreamNotificationCombinedNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<
        StreamNotificationCombinedNotifier, List<Map<String, dynamic>>> {
  /// See also [StreamNotificationCombinedNotifier].
  StreamNotificationCombinedNotifierProvider(
    String uid,
  ) : this._internal(
          () => StreamNotificationCombinedNotifier()..uid = uid,
          from: streamNotificationCombinedNotifierProvider,
          name: r'streamNotificationCombinedNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamNotificationCombinedNotifierHash,
          dependencies: StreamNotificationCombinedNotifierFamily._dependencies,
          allTransitiveDependencies: StreamNotificationCombinedNotifierFamily
              ._allTransitiveDependencies,
          uid: uid,
        );

  StreamNotificationCombinedNotifierProvider._internal(
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
    covariant StreamNotificationCombinedNotifier notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(StreamNotificationCombinedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamNotificationCombinedNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<StreamNotificationCombinedNotifier,
      List<Map<String, dynamic>>> createElement() {
    return _StreamNotificationCombinedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamNotificationCombinedNotifierProvider &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StreamNotificationCombinedNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _StreamNotificationCombinedNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        StreamNotificationCombinedNotifier,
        List<Map<String, dynamic>>> with StreamNotificationCombinedNotifierRef {
  _StreamNotificationCombinedNotifierProviderElement(super.provider);

  @override
  String get uid => (origin as StreamNotificationCombinedNotifierProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
