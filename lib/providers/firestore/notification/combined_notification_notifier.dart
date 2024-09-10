import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../models/notification/notification.dart';

part 'combined_notification_notifier.g.dart';

@riverpod
class StreamNotificationCombinedNotifier extends _$StreamNotificationCombinedNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String uid) {
    return FirebaseFirestore.instance
        .collection("notifications")
        .snapshots()
        .asyncMap((notificationSnapshot) async {
          List<Map<String, dynamic>> combinedNotifications = [];

          for (var notificationDoc in notificationSnapshot.docs) {
            // Check if the report exists for this notification
            final reportsSnapshot = await notificationDoc.reference
                .collection("reports")
                .doc(uid)
                .get();

            // Parse the notification
            final noti = Noti.fromJson(notificationDoc.data());

            // Add the notification to the list, marking it as answered or not answered
            combinedNotifications.add({
              'noti': noti,
              'docId': notificationDoc.id,
              'answered': reportsSnapshot.exists, // Mark as answered if the report exists
            });
          }
          
          return combinedNotifications;
        });
  }
}
