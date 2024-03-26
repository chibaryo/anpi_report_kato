import 'dart:developer';
import 'dart:io';

import 'package:anpi_report_ios/platform-dependent/fcm/initfcm_android.dart';
import 'package:anpi_report_ios/platform-dependent/fcm/initfcm_ios.dart';
import 'package:anpi_report_ios/providers/firestore/deviceinfotable/fcmtoken_provider.dart';
import 'package:anpi_report_ios/providers/firestore/user_provider.dart';
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
import 'package:device_imei/device_imei.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '../../models/deviceinfotable.dart';
import '../../models/prevnotis.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/deviceinfotable/deviceinfotable_provider.dart';
import '../../providers/firestore/userreport_provider.dart';
import '../../providers/geolocator/location_provider.dart';
import '../../widgets/fcmalertdialog.dart';

final logger = Logger();

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final isLoading = useState(false);
    final authState = ref.watch(firebaseAuthProvider);
    final prevnotisstream = ref.watch(prevNotisStreamProvider);

    //final locationInfo = ref.watch(geocodingControllerProvider);
    //final currentAddress = ref.watch(addressDataProvider);
    //
    final systemName = useState("");
    final osVersion = useState("");
    final localizedModel = useState("");
    final productName = useState("");
    final uDID = useState("");
    //
    final uDIDNotifier = ref.watch(udidNotifierProvider);
    final fcmTokenNotifier = ref.watch(fcmTokenNotifierProvider);

    Future<void> getDevInfo() async {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;

        systemName.value = iosInfo.systemName;
        osVersion.value = iosInfo.systemVersion;
        localizedModel.value = iosInfo.localizedModel;
        final iosMachine = iosInfo.utsname.machine;
        productName.value = iosMachine.iOSProductName;
        uDID.value = iosInfo.identifierForVendor!;

        debugPrint("uDID.value : ${uDID.value}");
        ref.read(udidNotifierProvider.notifier).state = iosInfo.identifierForVendor!;
      } else if (Platform.isAndroid) {
        await FlutterDeviceIdentifier.requestPermission();
        String androidID = await FlutterDeviceIdentifier.androidID;
        debugPrint("### Android ### androidID: $androidID");

        final androidInfo = await deviceInfoPlugin.androidInfo;

        debugPrint("androidInfo: ${androidInfo.toString()}");
        systemName.value = "Android";
        osVersion.value = androidInfo.version.release;
        localizedModel.value = androidInfo.display;
        productName.value = androidInfo.product;
        uDID.value = androidID;

      }
    }

    Future<void> addDeviceInfo() async {
      final serverDate = DateTime.now();
      await FirebaseFirestore.instance
        .collection("tokens")
        .doc(authState.currentUser?.uid)
        .collection("platforms")
        .doc(uDID.value)
        .set({
          "systemName": systemName.value,
          "osVersion": osVersion.value,
          "localizedModel": localizedModel.value,
          "productName": productName.value,
          "udId": uDID.value,
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
          .doc(uDID.value)
          .get();

        return docSnapshot;
    }

    Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserDocByUid() async {
        final docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(authState.currentUser?.uid)
          .get();
        
        return docSnapshot;
    }

    Future<void> toggleFirebaseUserOnlineStatus({
      required String uid,
      required bool isOnlineStatus
    }) async {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          "isOnline": isOnlineStatus,
        });
    }

    Future<List<DataRow>> buildDataRows(List<PrevNotis> prevs) async {
      final notAnsweredList = prevs.where((element) => !element.isMeResponded);
      final notAnsweredCnt = notAnsweredList.length;
      debugPrint("notAnsweredCnt: $notAnsweredCnt");
      if (await FlutterAppBadger.isAppBadgeSupported()) {
        FlutterAppBadger.updateBadgeCount(notAnsweredCnt);
      }

      return Future.wait(prevs.map<Future<DataRow>>((e) async {
        final docSnap = await FirebaseFirestore.instance
          .collection("notifications")
          .doc(e.notificationId)
          .get();
        final data = docSnap.data();
        DateTime itemDay = data!["createdAt"].toDate();
        itemDay = itemDay.add(const Duration(hours: 9));
        debugPrint("### date ###: ${itemDay.month}/${itemDay.day}");

        return DataRow(cells: <DataCell>[
          DataCell(Text("[${itemDay.month}/${itemDay.day} ${itemDay.hour}:${itemDay.minute}] ${data["notiTitle"]}")),
            DataCell(Text(e.isMeResponded ? "回答済み" : "未回答")),
        ]);
      })).then((rows) => rows.toList());
    }

    useEffect(() {
      getDevInfo().then((value) {
        addDeviceInfo().then((value) {
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
            } else {
              // Get one user
              getUserDocByUid().then((value) {
                final data = value.data();
                final isOnlineStatus = data!['isOnline'];
                debugPrint("user data!['isOnline']: $isOnlineStatus");

                //
                if (!isOnlineStatus) {
                  debugPrint("### still offline ###");
                  debugPrint("Existing devicedata: $data");
                  // Only renew fcmtoken
                  if (Platform.isIOS) {
                    initFCMIOS(authState.currentUser!.uid, uDID.value);
                  } else if (Platform.isAndroid) {
                    initFCMAndroid(authState.currentUser!.uid, uDID.value).then((fcmToken) {
                      debugPrint("fcmToken: $fcmToken");
                      ref.read(fcmTokenNotifierProvider.notifier).update(fcmToken!);
                    });
                  }
                  // set flag on
                  ref.read(asyncFirebaseUserNotifierProvider.notifier).toggleFirebaseUserOnlineStatus(
                    uid: authState.currentUser!.uid,
                    isOnlineStatus: true
                  ); // toggleFirebaseUserOnlineStatus(
                  // Store udid
                  ref.read(udidNotifierProvider.notifier).update(uDID.value);
                }
              });
            }
          });
        });
      });

/*
      queryDeviceInfoTableByUDID(
        authState.currentUser!.uid,
        uDID
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

    var body = Center(
        child: Column(
          children: <Widget>[
            const Text(
              '今までの緊急速報',
              style: TextStyle(fontSize: 32.0),
            ),
            authState.currentUser != null
              ? Text("${authState.currentUser!.displayName} さん")
              : const Text("uid"),
          // 回答済み
          prevnotisstream.when(
            data: (prevs) {
                return prevs == null
                  ? const Text("通知がありません")
                  : FutureBuilder<List<DataRow>>(
                  future: buildDataRows(prevs),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "通知名",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "回答ステータス",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: snapshot.data ?? const <DataRow>[],
                      );
                    }
                  },
                );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              debugPrint(error.toString());
              return Center(child: Text('Error: $error'));
            },
          ),

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
                        context.pushNamed("PostEnqueteScreen");
                      },
                      child: const Text("回答する"),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      );

    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: const Center(
                      child: Text(
                        "ロード中です...お待ちください..."
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );

    return Scaffold(
      body: isLoading.value ? bodyProgress : body,
    );
  }
}
