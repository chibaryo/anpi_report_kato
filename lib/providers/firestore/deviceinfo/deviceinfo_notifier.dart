import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/deviceinfo.dart';

part 'deviceinfo_notifier.g.dart';

@riverpod
class StreamDeviceInfoNotifier extends  _$StreamDeviceInfoNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collectionGroup("deviceinfo")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final deviceinfo = DeviceInfo.fromJson(doc.data());
        return {
          'deviceinfo': deviceinfo,
          'docId': doc.id,
        };
      }).toList());
  }

    // Get a profile by UID
  Future<DeviceInfo?> getDeviceInfoByUid(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("deviceinfo")
        .doc(uid)
        .get();

      if (doc.exists) {
        return DeviceInfo.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      // Handle error
      return null;
    }
  }


  // Add a new record
  Future<void> addDeviceInfo(String uid, DeviceInfo deviceinfo) async {
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("deviceinfo")
        .doc(uid)
        .set(deviceinfo.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update fcmToken
  Future<void> updateFcmTokenInDeviceInfo(String uid, String fcmToken) async {
    try {
      final deviceInfoRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("deviceinfo")
        .doc(uid);
      
      await deviceInfoRef.update({
        "fcmTokens": {
          "token": fcmToken,
          "updatedAt": DateTime.now(),
        },
      });

    } catch (e) {
      // Handle error
    }
  }

}