// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceinfotable_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'963402713bf9b7cc1fb259d619d9b0184d4dcec1';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseFirestoreRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$udidNotifierHash() => r'a1e777fff1cc0b78a29b6a983b7d13b3c5fc6ca0';

/// See also [UdidNotifier].
@ProviderFor(UdidNotifier)
final udidNotifierProvider =
    AutoDisposeNotifierProvider<UdidNotifier, String>.internal(
  UdidNotifier.new,
  name: r'udidNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$udidNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UdidNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
