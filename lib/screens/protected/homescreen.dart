import 'dart:developer';
import 'dart:io';

import 'package:anpi_report_ios/platform-dependent/fcm/initfcm_ios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ios_utsname_ext/extension.dart';

import '../../models/deviceinfotable.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/deviceinfotable/deviceinfotable_provider.dart';
import '../../providers/geolocator/location_provider.dart';
import '../../widgets/fcmalertdialog.dart';

final logger = Logger();

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
    final locationInfo = ref.watch(geocodingControllerProvider);
    final currentAddress = ref.watch(addressDataProvider);
    //
    final iosSystemName = useState("");
    final iosOsVersion = useState("");
    final iosLocalizedModel = useState("");
    final iosProductName = useState("");
    final iosUDID = useState("");
    //
    final iosUDIDNotifier = ref.watch(iOSUdidNotifierProvider);

    Future<void> getDevInfo() async {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;

        iosSystemName.value = iosInfo.systemName;
        iosOsVersion.value = iosInfo.systemVersion;
        iosLocalizedModel.value = iosInfo.localizedModel;
        final iosMachine = iosInfo.utsname.machine;
        iosProductName.value = iosMachine.iOSProductName;
        iosUDID.value = iosInfo.identifierForVendor!;

        debugPrint("iosUDID.value : ${iosUDID.value}");
        ref.read(iOSUdidNotifierProvider.notifier).state = iosInfo.identifierForVendor!;

      }
    }

    Future<void> addDeviceInfo() async {
      final serverDate = DateTime.now();
      await FirebaseFirestore.instance
        .collection("tokens")
        .doc(authState.currentUser?.uid)
        .collection("platforms")
        .doc(iosUDID.value)
        .set({
          "systemName": iosSystemName.value,
          "osVersion": iosOsVersion.value,
          "localizedModel": iosLocalizedModel.value,
          "productName": iosProductName.value,
          "udId": iosUDID.value,
//          "fcmToken": "",
          "createdAt": serverDate,
          "updatedAt": serverDate,
        });
    }

    Future<DocumentSnapshot<Map<String, dynamic>>>
      getPlatformDeviceInfoByUdid() async {
        final docSnapshot = await FirebaseFirestore.instance
          .collection("tokens")
          .doc(authState.currentUser?.uid)
          .collection("platforms")
          .doc(iosUDID.value)
          .get();

        return docSnapshot;
      }


    useEffect(() {
      getDevInfo().then((value) {
//        addDeviceInfo().then((value) {
          getPlatformDeviceInfoByUdid().then((value) {
            final data = value.data();
            debugPrint("data: $data");
            if (data == null || data!.isEmpty || data["fcmToken"] == "") {
              debugPrint("Data empty");
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return const FcmAlertDialog();
                }
              );
              addDeviceInfo();
            } else {
              debugPrint("Existing devicedata: $data");
              // Only renew fcmtoken
              initFCMIOS(authState.currentUser!.uid, iosUDID.value);
            }
          });
       // });
      });

/*
      queryDeviceInfoTableByUDID(
        authState.currentUser!.uid,
        iosUDID
      ).then((value) {
        debugPrint("value: $value");
        if (value.isNotEmpty && value[0].fcmToken != "") {
          debugPrint("value[0].fcmToken : ${value[0].fcmToken}");
        } else if (value.isEmpty || value[0].fcmToken == "") {
          debugPrint("fcmToken is empty or no udid found. so add one record.");
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return const FcmAlertDialog();
            }
          );

          // add to Firestore sub-collection

        };
      }); */

      return () {};

    }, const []);

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              '今までの緊急速報',
              style: TextStyle(fontSize: 32.0),
            ),
            authState.currentUser != null
              ? Text("${authState.currentUser!.displayName} さん")
              : const Text("uid"),
          //
          Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(geocodingControllerProvider.notifier).getCurrentAddress().then((address) {
                          FirebaseFirestore.instance
                            .collection("locations")
                            .doc(authState.currentUser?.uid)
                            .set({
                              "address": FieldValue.arrayUnion(
                                [
                                  address.country,
                                  address.prefecture,
                                  address.city,
                                  address.street
                                ]
                              )
                            });
                            // Store to provider
                            ref.read(addressDataProvider.notifier).setAddress([
                              address.country,
                              address.prefecture,
                              address.city,
                              address.street
                            ]);
                            debugPrint("### currentAddress : ${currentAddress.toString()} ###");

                          context.pushNamed("PostEnqueteScreen");
                        });
                      },
                      child: const Text("回答する"),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
