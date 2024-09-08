import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/notification/notification.dart';

part 'notifications_answered_byme_notifier.g.dart';

@riverpod
class StreamNotificationAnswerByMeNotifier extends _$StreamNotificationAnswerByMeNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String uid) async* {
    // Get all notifications
    yield* FirebaseFirestore.instance
      .collection("notifications")
      .snapshots()
      .asyncMap((notificationSnapshot) async {
        List<Map<String, dynamic>> notificationsWithReports = [];

        for (var notificationDoc in notificationSnapshot.docs) {
          // Get the subcollection 'reports' for each notification and check if a report with the given uid exists
          final reportsSnapshot = await notificationDoc.reference
              .collection("reports")
              .doc(uid)
              .get();

          // If a report for this uid exists, add the notification to the list
          if (reportsSnapshot.exists) {
            final noti = Noti.fromJson(notificationDoc.data());
            notificationsWithReports.add({
              'noti': noti,
              'docId': notificationDoc.id,
            });
          }
        }
        return notificationsWithReports;
      });
  }
}