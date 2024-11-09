import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/notification/notification.dart';

part 'notification_notifier.g.dart';

@riverpod
class StreamNotificationNotifier extends  _$StreamNotificationNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collection("notifications")
      .orderBy("createdAt", descending: true) // Order by descending directly here
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final noti = Noti.fromJson(doc.data());
        return {
          'noti': noti,
          'docId': doc.id,
        };
      }).toList());
  }

  // Get a profile by UID
  Future<Noti?> getNotificationByNotiId(String notificationId) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationId)
        .get();
    
      if (doc.exists) {
        print("doc.data(): ${doc.data()}");
        return Noti.fromJson(doc.data()!);
      } else {
        print("not dound");
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }

  // Add a new record
  Future<void> addNotification(String notificationId, Noti notification) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationId)
        .set(notification.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  Future<void> deleteNotificationById(String notificationId) async {
    try {
      await FirebaseFirestore.instance
        .collection("notifications")
        .doc(notificationId)
        .delete();
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

}
