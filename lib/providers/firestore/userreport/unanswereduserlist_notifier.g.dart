// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unanswereduserlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUnansweredUsersHash() =>
    r'fb094941983f554782e0e15ab5473a1fdaf0b6c2';

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

/// See also [fetchUnansweredUsers].
@ProviderFor(fetchUnansweredUsers)
const fetchUnansweredUsersProvider = FetchUnansweredUsersFamily();

/// See also [fetchUnansweredUsers].
class FetchUnansweredUsersFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [fetchUnansweredUsers].
  const FetchUnansweredUsersFamily();

  /// See also [fetchUnansweredUsers].
  FetchUnansweredUsersProvider call(
    String notiId,
  ) {
    return FetchUnansweredUsersProvider(
      notiId,
    );
  }

  @override
  FetchUnansweredUsersProvider getProviderOverride(
    covariant FetchUnansweredUsersProvider provider,
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
  String? get name => r'fetchUnansweredUsersProvider';
}

/// See also [fetchUnansweredUsers].
class FetchUnansweredUsersProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [fetchUnansweredUsers].
  FetchUnansweredUsersProvider(
    String notiId,
  ) : this._internal(
          (ref) => fetchUnansweredUsers(
            ref as FetchUnansweredUsersRef,
            notiId,
          ),
          from: fetchUnansweredUsersProvider,
          name: r'fetchUnansweredUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnansweredUsersHash,
          dependencies: FetchUnansweredUsersFamily._dependencies,
          allTransitiveDependencies:
              FetchUnansweredUsersFamily._allTransitiveDependencies,
          notiId: notiId,
        );

  FetchUnansweredUsersProvider._internal(
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
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
            FetchUnansweredUsersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUnansweredUsersProvider._internal(
        (ref) => create(ref as FetchUnansweredUsersRef),
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
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _FetchUnansweredUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnansweredUsersProvider && other.notiId == notiId;
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
mixin FetchUnansweredUsersRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `notiId` of this provider.
  String get notiId;
}

class _FetchUnansweredUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with FetchUnansweredUsersRef {
  _FetchUnansweredUsersProviderElement(super.provider);

  @override
  String get notiId => (origin as FetchUnansweredUsersProvider).notiId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
