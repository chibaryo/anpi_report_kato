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
        .orderBy("createdAt", descending: true) // Order by descending directly here
        .snapshots()
        .asyncMap((notificationSnapshot) async {
          List<Map<String, dynamic>> combinedNotifications = [];

          for (var notificationDoc in notificationSnapshot.docs) {
            // Check if the report exists for this notification
            final reportsSnapshot = await notificationDoc.reference
                .collection("ureports")
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

          // Sort the combinedNotifications list by createdAt to maintain the correct order
/*          combinedNotifications.sort((a, b) {
            final aCreatedAt = (a['noti'] as Noti).createdAt;
            final bCreatedAt = (b['noti'] as Noti).createdAt;
            return bCreatedAt!.compareTo(aCreatedAt!); // Sort in ascending order
          }); */

          print("### combinedNotifications  ###: ${combinedNotifications.toString()}");
          
          return combinedNotifications;
        });
  }
}
