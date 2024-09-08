import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/notification/notification.dart';

part 'combined_notification_notifier.g.dart';

@riverpod
class StreamNotificationCombinedNotifier extends _$StreamNotificationCombinedNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String uid) {
    final answeredStream = FirebaseFirestore.instance
        .collection("notifications")
        .snapshots()
        .asyncMap((notificationSnapshot) async {
          List<Map<String, dynamic>> notificationsWithReports = [];

          for (var notificationDoc in notificationSnapshot.docs) {
            final reportsSnapshot = await notificationDoc.reference
                .collection("reports")
                .doc(uid)
                .get();

            if (reportsSnapshot.exists) {
              final noti = Noti.fromJson(notificationDoc.data());
              notificationsWithReports.add({
                'noti': noti,
                'docId': notificationDoc.id,
                'answered': true, // Mark as answered
              });
            }
          }
          return notificationsWithReports;
        });

    final notAnsweredStream = FirebaseFirestore.instance
        .collection("notifications")
        .snapshots()
        .asyncMap((notificationSnapshot) async {
          List<Map<String, dynamic>> notificationsWithoutReports = [];

          for (var notificationDoc in notificationSnapshot.docs) {
            final reportsSnapshot = await notificationDoc.reference
                .collection("reports")
                .doc(uid)
                .get();

            if (!reportsSnapshot.exists) {
              final noti = Noti.fromJson(notificationDoc.data());
              notificationsWithoutReports.add({
                'noti': noti,
                'docId': notificationDoc.id,
                'answered': false, // Mark as not answered
              });
            }
          }
          return notificationsWithoutReports;
        });

    // Use Rx.combineLatest to combine both streams
    return CombineLatestStream.combine2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      answeredStream,
      notAnsweredStream,
      (answered, notAnswered) => [...answered, ...notAnswered], // Combine both into one list
    );
  }
}