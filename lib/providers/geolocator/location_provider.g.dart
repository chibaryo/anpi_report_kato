// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geocodingControllerHash() =>
    r'5533a63e6046048ab81d21af1d35cdbef727ce92';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
