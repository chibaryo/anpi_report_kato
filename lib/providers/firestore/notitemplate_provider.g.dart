// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notitemplate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'230b9276da2e44bb1aa6b300e1ddbb2f93c422da';

///
///
/// Copied from [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider =
    AutoDisposeProvider<FirebaseFirestore>.internal(
  firebaseFirestore,
  name: r'firebaseFirestoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseFirestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseFirestoreRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$notiTemplateStreamHash() =>
    r'be47346591a35b30832314bcee9e5a4a1e802e74';

/// See also [notiTemplateStream].
@ProviderFor(notiTemplateStream)
final notiTemplateStreamProvider =
    AutoDisposeStreamProvider<List<NotiTemplate>>.internal(
  notiTemplateStream,
  name: r'notiTemplateStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notiTemplateStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotiTemplateStreamRef
    = AutoDisposeStreamProviderRef<List<NotiTemplate>>;
String _$asyncNotiTemplateNotifierHash() =>
    r'7e5ec13be286a7da6f65c383d864ef4874a5990b';

/// See also [AsyncNotiTemplateNotifier].
@ProviderFor(AsyncNotiTemplateNotifier)
final asyncNotiTemplateNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AsyncNotiTemplateNotifier, List<NotiTemplate>>.internal(
  AsyncNotiTemplateNotifier.new,
  name: r'asyncNotiTemplateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$asyncNotiTemplateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncNotiTemplateNotifier
    = AutoDisposeAsyncNotifier<List<NotiTemplate>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
