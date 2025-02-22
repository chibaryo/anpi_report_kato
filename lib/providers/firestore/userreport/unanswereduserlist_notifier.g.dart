// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unanswereduserlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamUnansweredUserNotifierHash() =>
    r'472e4f8c4bcd1797fa17fff3581f15fb111d22e9';

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

abstract class _$StreamUnansweredUserNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Map<String, dynamic>>> {
  late final String notiId;

  Stream<List<Map<String, dynamic>>> build(
    String notiId,
  );
}

/// See also [StreamUnansweredUserNotifier].
@ProviderFor(StreamUnansweredUserNotifier)
const streamUnansweredUserNotifierProvider =
    StreamUnansweredUserNotifierFamily();

/// See also [StreamUnansweredUserNotifier].
class StreamUnansweredUserNotifierFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [StreamUnansweredUserNotifier].
  const StreamUnansweredUserNotifierFamily();

  /// See also [StreamUnansweredUserNotifier].
  StreamUnansweredUserNotifierProvider call(
    String notiId,
  ) {
    return StreamUnansweredUserNotifierProvider(
      notiId,
    );
  }

  @override
  StreamUnansweredUserNotifierProvider getProviderOverride(
    covariant StreamUnansweredUserNotifierProvider provider,
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
  String? get name => r'streamUnansweredUserNotifierProvider';
}

/// See also [StreamUnansweredUserNotifier].
class StreamUnansweredUserNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<StreamUnansweredUserNotifier,
        List<Map<String, dynamic>>> {
  /// See also [StreamUnansweredUserNotifier].
  StreamUnansweredUserNotifierProvider(
    String notiId,
  ) : this._internal(
          () => StreamUnansweredUserNotifier()..notiId = notiId,
          from: streamUnansweredUserNotifierProvider,
          name: r'streamUnansweredUserNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamUnansweredUserNotifierHash,
          dependencies: StreamUnansweredUserNotifierFamily._dependencies,
          allTransitiveDependencies:
              StreamUnansweredUserNotifierFamily._allTransitiveDependencies,
          notiId: notiId,
        );

  StreamUnansweredUserNotifierProvider._internal(
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
    covariant StreamUnansweredUserNotifier notifier,
  ) {
    return notifier.build(
      notiId,
    );
  }

  @override
  Override overrideWith(StreamUnansweredUserNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamUnansweredUserNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<StreamUnansweredUserNotifier,
      List<Map<String, dynamic>>> createElement() {
    return _StreamUnansweredUserNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamUnansweredUserNotifierProvider &&
        other.notiId == notiId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notiId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StreamUnansweredUserNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `notiId` of this provider.
  String get notiId;
}

class _StreamUnansweredUserNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        StreamUnansweredUserNotifier,
        List<Map<String, dynamic>>> with StreamUnansweredUserNotifierRef {
  _StreamUnansweredUserNotifierProviderElement(super.provider);

  @override
  String get notiId => (origin as StreamUnansweredUserNotifierProvider).notiId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
