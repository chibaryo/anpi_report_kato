import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/address.dart';

part 'location_provider.g.dart';

@riverpod
class GeocodingController extends _$GeocodingController {
  late bool isServiceEnabled;
  late LocationPermission permission;

/*  @override
  Future<void> build() async {
    return;
  }*/

  @override
  FutureOr<void> build() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error("Location services are disabled");
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error("Location permissions are denied");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denined, we cannot request permissions.");
      }

//      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> getPlacemarkFromPosition(
      {required double latitude, required double longitude}) async {
    final placeMarks = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks?[0];
    return placeMark;
  }

  Future<Address> getCurrentAddress() async {
    final currentPosition = await getCurrentPosition();
    final placeMark = await getPlacemarkFromPosition(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );
    final address = Address(
      country: placeMark?.country ?? '',
      prefecture: placeMark?.administrativeArea ?? '',
      city: placeMark?.locality ?? '',
      street: placeMark?.street ?? '',
    );
    return address;
  }

  Future<Address> getAddressInfoFromPosition(
      {required double latitude, required double longitude}) async {
    final placeMark = await getPlacemarkFromPosition(
        latitude: latitude, longitude: longitude);
    final address = Address(
      country: placeMark!.country ?? '',
      prefecture: placeMark.administrativeArea ?? '',
      city: placeMark.locality ?? '',
      street: placeMark.street ?? '',
    );
    return address;
  }
}

@riverpod
class AddressData extends _$AddressData {
  @override
  List<String> build() {
    return [];
  }

  void setAddress(List<String> address) {
    state = [...address];
  }
}
