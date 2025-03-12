// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'912368c3df3f72e4295bf7a8cda93b9c5749d923';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = AutoDisposeProvider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = AutoDisposeProviderRef<FirebaseAuth>;
String _$streamAuthNotifierHash() =>
    r'bd71564d6052966321148fb5ed99b3f7cc5e011a';

/// [認証状態を監視するプロバイダー]
///
/// Copied from [StreamAuthNotifier].
@ProviderFor(StreamAuthNotifier)
final streamAuthNotifierProvider =
    AutoDisposeStreamNotifierProvider<StreamAuthNotifier, User?>.internal(
  StreamAuthNotifier.new,
  name: r'streamAuthNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamAuthNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreamAuthNotifier = AutoDisposeStreamNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
