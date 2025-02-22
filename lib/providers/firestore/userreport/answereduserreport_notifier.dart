import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/userreport.dart';

part 'answereduserreport_notifier.g.dart';

@riverpod
class StreamAnsweredUserReportNotifier extends  _$StreamAnsweredUserReportNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String notiId) async* {
    yield* FirebaseFirestore.instance
      .collection("notifications")
      .doc(notiId)
      .collection("ureports")
      .snapshots()
      .asyncMap((snapshot) async {
        final combinedData = <Map<String, dynamic>>[];

        for (final doc in snapshot.docs) {
          final report = UserReport.fromJson(doc.data());
          final userRef = report.userRef;
          final profileRef = report.profileRef;

          // Fetch user data
          final userDoc = await userRef.get();
          final user = userDoc.exists ? userDoc.data() : null;

          // Fetch profile data
          final profileDoc = await profileRef.get();
          final profile = profileDoc.exists ? profileDoc.data() : null;

          // Combine data
          combinedData.add({
            'report': report,
            'docId': doc.id,
            'user': user,
            'profile': profile,
          });
        }

        return combinedData;
      });
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
  Future<void> addUserReport(String notiId, String uid, UserReport ureport) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("ureports")
        .doc(uid)
        .set(ureport.toJson());
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
