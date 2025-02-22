// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answereduserreport_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamAnsweredUserReportNotifierHash() =>
    r'0d669747bba15b7ca98c8ab398e3ee259d149b5c';

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

abstract class _$StreamAnsweredUserReportNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Map<String, dynamic>>> {
  late final String notiId;

  Stream<List<Map<String, dynamic>>> build(
    String notiId,
  );
}

/// See also [StreamAnsweredUserReportNotifier].
@ProviderFor(StreamAnsweredUserReportNotifier)
const streamAnsweredUserReportNotifierProvider =
    StreamAnsweredUserReportNotifierFamily();

/// See also [StreamAnsweredUserReportNotifier].
class StreamAnsweredUserReportNotifierFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [StreamAnsweredUserReportNotifier].
  const StreamAnsweredUserReportNotifierFamily();

  /// See also [StreamAnsweredUserReportNotifier].
  StreamAnsweredUserReportNotifierProvider call(
    String notiId,
  ) {
    return StreamAnsweredUserReportNotifierProvider(
      notiId,
    );
  }

  @override
  StreamAnsweredUserReportNotifierProvider getProviderOverride(
    covariant StreamAnsweredUserReportNotifierProvider provider,
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
  String? get name => r'streamAnsweredUserReportNotifierProvider';
}

/// See also [StreamAnsweredUserReportNotifier].
class StreamAnsweredUserReportNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<
        StreamAnsweredUserReportNotifier, List<Map<String, dynamic>>> {
  /// See also [StreamAnsweredUserReportNotifier].
  StreamAnsweredUserReportNotifierProvider(
    String notiId,
  ) : this._internal(
          () => StreamAnsweredUserReportNotifier()..notiId = notiId,
          from: streamAnsweredUserReportNotifierProvider,
          name: r'streamAnsweredUserReportNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$streamAnsweredUserReportNotifierHash,
          dependencies: StreamAnsweredUserReportNotifierFamily._dependencies,
          allTransitiveDependencies:
              StreamAnsweredUserReportNotifierFamily._allTransitiveDependencies,
          notiId: notiId,
        );

  StreamAnsweredUserReportNotifierProvider._internal(
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
    covariant StreamAnsweredUserReportNotifier notifier,
  ) {
    return notifier.build(
      notiId,
    );
  }

  @override
  Override overrideWith(StreamAnsweredUserReportNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamAnsweredUserReportNotifierProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<StreamAnsweredUserReportNotifier,
      List<Map<String, dynamic>>> createElement() {
    return _StreamAnsweredUserReportNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreamAnsweredUserReportNotifierProvider &&
        other.notiId == notiId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, notiId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StreamAnsweredUserReportNotifierRef
    on AutoDisposeStreamNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `notiId` of this provider.
  String get notiId;
}

class _StreamAnsweredUserReportNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        StreamAnsweredUserReportNotifier,
        List<Map<String, dynamic>>> with StreamAnsweredUserReportNotifierRef {
  _StreamAnsweredUserReportNotifierProviderElement(super.provider);

  @override
  String get notiId =>
      (origin as StreamAnsweredUserReportNotifierProvider).notiId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
