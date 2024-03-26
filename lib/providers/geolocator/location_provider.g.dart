// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geocodingControllerHash() =>
    r'7800e5898eced0d008d036411ab32c1d2eac77bc';

/// See also [GeocodingController].
@ProviderFor(GeocodingController)
final geocodingControllerProvider =
    AutoDisposeAsyncNotifierProvider<GeocodingController, void>.internal(
  GeocodingController.new,
  name: r'geocodingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$geocodingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GeocodingController = AutoDisposeAsyncNotifier<void>;
String _$addressDataHash() => r'b356cef8bac987ca773c1548254b632bb61a8b20';

/// See also [AddressData].
@ProviderFor(AddressData)
final addressDataProvider =
    AutoDisposeNotifierProvider<AddressData, List<String>>.internal(
  AddressData.new,
  name: r'addressDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addressDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddressData = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
