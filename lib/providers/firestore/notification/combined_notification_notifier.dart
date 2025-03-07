import 'package:anpi_report_flutter/entity/topictype.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
          final profileDoc = await FirebaseFirestore.instance.collection("users").doc(uid).collection("profiles").doc(uid).get();
          final profile = profileDoc.data();
          final mySubscription = profile?["userAttr"]["subscription"];

          List<Map<String, dynamic>> combinedNotifications = [];

          for (var notificationDoc in notificationSnapshot.docs) {
            // Check if the report exists for this notification
            final reportsSnapshot = await notificationDoc.reference
                .collection("ureports")
                .doc(uid)
                .get();

            // Parse the notification
            final noti = Noti.fromJson(notificationDoc.data());
            final isMySubscription = calcSubscriptionBitmask(noti.notiTopic, mySubscription); // Calc mySubscription and noti.notiTopic

            // Filter notifications where isMySubscription is true
            if (isMySubscription) {
              // Add the notification to the list, marking it as answered or not answered
              combinedNotifications.add({
                'noti': noti,
                'docId': notificationDoc.id,
                'answered': reportsSnapshot.exists, // Mark as answered if the report exists
              });
            }
          }

          // Sort the combinedNotifications list by createdAt to maintain the correct order
/*          combinedNotifications.sort((a, b) {
            final aCreatedAt = (a['noti'] as Noti).createdAt;
            final bCreatedAt = (b['noti'] as Noti).createdAt;
            return bCreatedAt!.compareTo(aCreatedAt!); // Sort in ascending order
          }); */

          
          return combinedNotifications;
        });
  }
}
