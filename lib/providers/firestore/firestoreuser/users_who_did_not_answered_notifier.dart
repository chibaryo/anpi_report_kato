import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/userreport.dart';

part 'users_who_did_not_answered_notifier.g.dart';

@riverpod
class StreamAnsOrNotAnsNotificationCombinedNotifier extends _$StreamAnsOrNotAnsNotificationCombinedNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String notiId) async* {
    yield* FirebaseFirestore.instance
      .collection("notifications")
      .doc(notiId)
      .collection("ureports")
      .snapshots()
      .map((reportSnap) => reportSnap.docs.map((doc) {
        final report = UserReport.fromJson(doc.data());
        return {
          'report': report,
          'docId': doc.id,
        };
      }).toList());
  }
}
