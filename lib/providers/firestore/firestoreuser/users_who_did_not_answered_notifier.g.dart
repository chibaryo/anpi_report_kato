// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_who_did_not_answered_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamAnsOrNotAnsNotificationCombinedNotifierHash() =>
    r'5efb8563f4ff5a986e1dfd0ec760d2a13625dd74';

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

abstract class _$StreamAnsOrNotAnsNotificationCombinedNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Map<String, dynamic>>> {
  late final String notiId;

  Stream<List<Map<String, dynamic>>> build(
    String notiId,
  );
}

/// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
@ProviderFor(StreamAnsOrNotAnsNotificationCombinedNotifier)
const streamAnsOrNotAnsNotificationCombinedNotifierProvider =
    StreamAnsOrNotAnsNotificationCombinedNotifierFamily();

/// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
class StreamAnsOrNotAnsNotificationCombinedNotifierFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
  const StreamAnsOrNotAnsNotificationCombinedNotifierFamily();

  /// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
  StreamAnsOrNotAnsNotificationCombinedNotifierProvider call(
    String notiId,
  ) {
    return StreamAnsOrNotAnsNotificationCombinedNotifierProvider(
      notiId,
    );
  }

  @override
  StreamAnsOrNotAnsNotificationCombinedNotifierProvider getProviderOverride(
    covariant StreamAnsOrNotAnsNotificationCombinedNotifierProvider provider,
  ) {
    return call(
      provider.notiId,
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
  String? get name => r'streamAnsOrNotAnsNotificationCombinedNotifierProvider';
}

/// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
class StreamAnsOrNotAnsNotificationCombinedNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<
        StreamAnsOrNotAnsNotificationCombinedNotifier,
        List<Map<String, dynamic>>> {
  /// See also [StreamAnsOrNotAnsNotificationCombinedNotifier].
  StreamAnsOrNotAnsNotificationCombinedNotifierProvider(
    String notiId,
  ) : this._internal(
          () =>
              StreamAnsOrNotAnsNotificationCombinedNotifier()..notiId = notiId,
          from: streamAnsOrNotAnsNotificationCombinedNotifierProvider,
          name: r'streamAnsOrNotAnsNotificationCombinedNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamAnsOrNotAnsNotificationCombinedNotifierHash,
          dependencies:
              StreamAnsOrNotAnsNotificationCombinedNotifierFamily._dependencies,
          allTransitiveDependencies:
              StreamAnsOrNotAnsNotificationCombinedNotifierFamily
                  ._allTransitiveDependencies,
          notiId: notiId,
        );

  StreamAnsOrNotAnsNotificationCombinedNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.notiId,
  }) : super.internal();

  final String notiId;

  @override
  Stream<List<Map<String, dynamic>>> runNotifierBuild(
    covariant StreamAnsOrNotAnsNotificationCombinedNotifier notifier,
  ) {
    return notifier.build(
      notiId,
    );
  }

  @override
  Override overrideWith(
      StreamAnsOrNotAnsNotificationCombinedNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamAnsOrNotAnsNotificationCombinedNotifierProvider._internal(
        () => create()..notiId = notiId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        notiId: notiId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<
      StreamAnsOrNotAnsNotificationCombinedNotifier,
      List<Map<String, dynamic>>> createElement() {
    return _StreamAnsOrNotAnsNotificationCombinedNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamAnsOrNotAnsNotificationCombinedNotifierProvider &&
        other.notiId == notiId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notiId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreamAnsOrNotAnsNotificationCombinedNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `notiId` of this provider.
  String get notiId;
}

class _StreamAnsOrNotAnsNotificationCombinedNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        StreamAnsOrNotAnsNotificationCombinedNotifier,
        List<Map<String, dynamic>>>
    with StreamAnsOrNotAnsNotificationCombinedNotifierRef {
  _StreamAnsOrNotAnsNotificationCombinedNotifierProviderElement(super.provider);

  @override
  String get notiId =>
      (origin as StreamAnsOrNotAnsNotificationCombinedNotifierProvider).notiId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
