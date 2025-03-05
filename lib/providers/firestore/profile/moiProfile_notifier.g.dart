// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moiProfile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamMoiProfileNotifierHash() =>
    r'a83a75ab4cd0f0388f809d8a54c822e4bbf01116';

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

abstract class _$StreamMoiProfileNotifier
    extends BuildlessAutoDisposeStreamNotifier<Profile?> {
  late final String uid;

  Stream<Profile?> build(
    String uid,
  );
}

/// See also [StreamMoiProfileNotifier].
@ProviderFor(StreamMoiProfileNotifier)
const streamMoiProfileNotifierProvider = StreamMoiProfileNotifierFamily();

/// See also [StreamMoiProfileNotifier].
class StreamMoiProfileNotifierFamily extends Family<AsyncValue<Profile?>> {
  /// See also [StreamMoiProfileNotifier].
  const StreamMoiProfileNotifierFamily();

  /// See also [StreamMoiProfileNotifier].
  StreamMoiProfileNotifierProvider call(
    String uid,
  ) {
    return StreamMoiProfileNotifierProvider(
      uid,
    );
  }

  @override
  StreamMoiProfileNotifierProvider getProviderOverride(
    covariant StreamMoiProfileNotifierProvider provider,
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
  String? get name => r'streamMoiProfileNotifierProvider';
}

/// See also [StreamMoiProfileNotifier].
class StreamMoiProfileNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<StreamMoiProfileNotifier,
        Profile?> {
  /// See also [StreamMoiProfileNotifier].
  StreamMoiProfileNotifierProvider(
    String uid,
  ) : this._internal(
          () => StreamMoiProfileNotifier()..uid = uid,
          from: streamMoiProfileNotifierProvider,
          name: r'streamMoiProfileNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamMoiProfileNotifierHash,
          dependencies: StreamMoiProfileNotifierFamily._dependencies,
          allTransitiveDependencies:
              StreamMoiProfileNotifierFamily._allTransitiveDependencies,
          uid: uid,
        );

  StreamMoiProfileNotifierProvider._internal(
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
  Stream<Profile?> runNotifierBuild(
    covariant StreamMoiProfileNotifier notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(StreamMoiProfileNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamMoiProfileNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<StreamMoiProfileNotifier, Profile?>
      createElement() {
    return _StreamMoiProfileNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamMoiProfileNotifierProvider && other.uid == uid;
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
mixin StreamMoiProfileNotifierRef
    on AutoDisposeStreamNotifierProviderRef<Profile?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _StreamMoiProfileNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<StreamMoiProfileNotifier,
        Profile?> with StreamMoiProfileNotifierRef {
  _StreamMoiProfileNotifierProviderElement(super.provider);

  @override
  String get uid => (origin as StreamMoiProfileNotifierProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
