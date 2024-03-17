// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceinfotable_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'230b9276da2e44bb1aa6b300e1ddbb2f93c422da';

/// See also [firebaseFirestore].
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
String _$iOSUdidNotifierHash() => r'7cef3cfdb171f2fa0acd44844b864a5a9f5d99e3';

/// See also [IOSUdidNotifier].
@ProviderFor(IOSUdidNotifier)
final iOSUdidNotifierProvider =
    AutoDisposeNotifierProvider<IOSUdidNotifier, String>.internal(
  IOSUdidNotifier.new,
  name: r'iOSUdidNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iOSUdidNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IOSUdidNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
