import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/report/report.dart';

part 'report_notifier.g.dart';

@riverpod
class StreamReportNotifier extends  _$StreamReportNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collection("reports")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final report = Report.fromJson(doc.data());
        return {
          'report': report,
          'docId': doc.id,
        };
      }).toList());
  }

  // Get a Report by UID
  Future<Report?> getReportByUid(String uid, String notiId) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("reports")
        .doc(uid)
        .get();
    
      if (doc.exists) {
        return Report.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }

  // Add a new record
  Future<void> addReport(String notiId, String uid, Report report) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("reports")
        .doc(uid)
        .set(report.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update an existing  record
  Future<void> updateReport(String notiId, String uid, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notiId)
        .collection("reports")
        .doc(uid)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

}
