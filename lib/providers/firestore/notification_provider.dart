import 'package:anpi_report_ios/models/notitemplate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/notification.dart';

part 'notification_provider.g.dart';

@riverpod
class AsyncNotificationNotifier extends _$AsyncNotificationNotifier {
  Future<List<Notification>> _fetchNotifications() async {
    final snapshots = await FirebaseFirestore.instance
      .collection('notifications')
//      .where("respondents", arrayContains: "Phrrgq7sijQ9VcInGJXdNmMlMGI2")
      .get();

    // データ(Map型)を取得
    return snapshots.docs.map((doc) => Notification.fromJson(doc.data())).toList();
  }

  @override
  FutureOr<List<Notification>> build() async {
    return _fetchNotifications();
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
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {

        // Add to firestore
        await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notificationId)
          .set({
            "notificationId": notificationId,
            "notiTitle": notiTitle,
            "notiBody": notiBody,
            "createdAt": serverDate,
          });
        return _fetchNotifications();
      } catch (err) {
        throw Exception(err);
      }
    });
  }


}


// Get one
/*
final getOneNotificationById = FutureProvider.family<Notification, String>((ref, notificationId) async {
  final snap = await FirebaseFirestore.instance
    .collection("notifications")
    .doc(notificationId)
    .get();

  return snap;
});
*/

