import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/deviceinfotable.dart';
part 'deviceinfotable_provider.g.dart';

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

Future<List<DeviceInfoTable>> queryDeviceInfoTableByUDID(String uid, String udId) async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore
        .collection("tokens")
        .doc(uid)
        .collection("platforms")
        .where("udId", isEqualTo: udId)
        .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();

    return DeviceInfoTable.fromJson(data);
  }).toList();

//        .map((snapshot) =>
  //        snapshot.docs.map((doc) => doc.data()).whereType<DeviceInfoTable>().toList());

      // return result.map((event) => event.docs.map((e) => e.data()).toList());
}

@riverpod
class UdidNotifier extends _$UdidNotifier {
  @override
  String build () {
    return "";
  }

  void update(String udId) {
    state = udId;
  }
}

