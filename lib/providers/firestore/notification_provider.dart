import 'package:anpi_report_ios/models/notitemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/notification.dart';

part 'notification_provider.g.dart';

@riverpod
class AsyncNotificationNotifier extends _$AsyncNotificationNotifier {
  Stream<List<Notification>> _notificationsStream() {
    return FirebaseFirestore.instance
      .collection('notifications')
      .snapshots()
      .map((snapshot) =>
        snapshot.docs.map((doc) => Notification.fromJson(doc.data())).toList()
      );
  }

  @override
  FutureOr<List<Notification>> build() async {
    // Using Stream for real-time updates
    return _notificationsStream().first; // Get the initial data
  }

  void listenToNotifications() {
    // Subscribe to the notifications stream
    _notificationsStream().listen((notifications) {
      state = AsyncValue.data(notifications);
    });
  }

  Future<Notification?> fetchNotificationByNotiId(String notiId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notiId)
          .get();

      if (doc.exists) {
        return Notification.fromJson(doc.data()!);
      } else {
        return null; // Handle if the notification doesn't exist
      }
    } catch (e) {
      throw Exception("Failed to fetch notification: $e");
    }
  }

  // CREATE(Add)
  Future<void> addNotification({
    required String notificationId,
    required String notiTitle,
    required String notiBody,
  }) async {
    final serverDate = DateTime.now();

    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new notification and reload the list
    state = await AsyncValue.guard(() async {
      try {
        await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notificationId)
          .set({
            "notificationId": notificationId,
            "notiTitle": notiTitle,
            "notiBody": notiBody,
            "createdAt": serverDate,
          });
        return _notificationsStream().first; // Return the updated list
      } catch (err) {
        throw Exception(err);
      }
    });
  }
}
