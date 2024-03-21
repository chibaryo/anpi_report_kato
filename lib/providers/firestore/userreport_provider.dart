import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/prevnotis.dart';
import '../../models/userreport.dart';
import '../firebaseauth/auth_provider.dart';

part 'userreport_provider.g.dart';

@riverpod
class AsyncUserReportNotifier extends _$AsyncUserReportNotifier {
  Future<List<UserReport>> _fetchUserReports() async {
    final snapshots = await FirebaseFirestore.instance.collection('reports').get();
    // データ(Map型)を取得
    return snapshots.docs.map((doc) => UserReport.fromJson(doc.data())).toList();
  }

  @override
  FutureOr<List<UserReport>> build() async {
    return _fetchUserReports();
  }

  // CREATE(Add)
  Future<void> addUserReport({
    required String uid,
    required String name,
    required int siteCode,
    required String reportId,
    required String issueId,
    required String anpiStatus,
    required String gotoOfficeStatus,
    required String message,
    required bool isLocationPermitted,
    List<String>? position,
    }) async {
    final serverDate = DateTime.now();

    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {

        // Add to firestore
        await FirebaseFirestore.instance
          .collection("reports")
          .doc(reportId)
          .set({
            "reportId": reportId,
            "issueId": issueId,
            "siteCode": siteCode,
            "uid": uid,
            "name": name,
            "anpiStatus": anpiStatus,
            "gotoOfficeStatus": gotoOfficeStatus,
            "message": message,
            "isLocationPermitted": isLocationPermitted,
            "position": FieldValue.arrayUnion(position!),
            "createdAt": serverDate,
          });
        return _fetchUserReports();
      } catch (err) {
        throw Exception(err);
      }
    });
  }


}

///
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
Stream<List<PrevNotis>> prevNotisStream (PrevNotisStreamRef ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final authState = ref.watch(firebaseAuthProvider);

  try {
  return firestore
    .collection("notifications")
    .orderBy("createdAt", descending: false)
    .withConverter<PrevNotis?>(fromFirestore:  (ds, _) {
      final data = ds.data();
//      final id = ds.id;

      if (data == null) {
        return null;
      }
      // If a_respondents is not empty
      if (data["a_respondents"] != null) {
        final uidList = data["a_respondents"];
        if (uidList.contains(authState.currentUser?.uid)) {
          data["uid"] = authState.currentUser?.uid;
          data["isMeResponded"] = true;
        }
      } else {
        data["uid"] = authState.currentUser?.uid;
        data["isMeResponded"] = false;
      }
 //     data['notificationId'] = id;
      return PrevNotis.fromJson(data);
    }, toFirestore: (prevnotis, _) {
      return prevnotis?.toJson() ?? {};
    })
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => doc.data()).whereType<PrevNotis>().toList());

  } catch (err) {
    throw Exception(err);
  }
 
}
