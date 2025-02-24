import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/userreport.dart';

part 'userreport_notifier.g.dart';

@riverpod
class StreamUserReportNotifier extends  _$StreamUserReportNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collectionGroup("ureports")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final userReport = UserReport.fromJson(doc.data());
        return {
          'ureport': userReport,
          'docId': doc.id,
        };
      }).toList());
  }

  // Get a Report by UID
  Future<UserReport?> getUserReportByUid(String uid, String notiId) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("ureports")
        .doc(uid)
        .get();
    
      if (doc.exists) {
        return UserReport.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }

  // Add a new record
  Future<void> addUserReport(String notiId, String uid, UserReport report) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("ureports")
        .doc(uid)
        .set(report.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update an existing  record
  Future<void> updateUserReport(String notiId, String uid, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("ureports")
        .doc(uid)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

}
