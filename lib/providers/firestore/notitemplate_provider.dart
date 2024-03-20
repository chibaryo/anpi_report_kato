import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/notitemplate.dart';

part 'notitemplate_provider.g.dart';

@riverpod
class AsyncNotiTemplateNotifier extends _$AsyncNotiTemplateNotifier {
  Future<List<NotiTemplate>> _fetchNotiTemplates() async {
    final snapshots = await FirebaseFirestore.instance
      .collection('notitemplates')
//      .where("respondents", arrayContains: "Phrrgq7sijQ9VcInGJXdNmMlMGI2")
      .get();

    // データ(Map型)を取得
    return snapshots.docs.map((doc) => NotiTemplate.fromJson(doc.data())).toList();
  }

  @override
  FutureOr<List<NotiTemplate>> build() async {
    return _fetchNotiTemplates();
  }

  // CREATE(Add)
  Future<void> addNotiTemplate({
    required String notiTemplateId,
    required String notiTitle,
    required String notiBody,
    required String mode,
    }) async {
    final serverDate = DateTime.now();

    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {

        // Add to firestore
        if (mode == "add") {
        await FirebaseFirestore.instance
          .collection("notitemplates")
          .doc(notiTemplateId)
          .set({
            "notiTemplateId": notiTemplateId,
            "notiTitle": notiTitle,
            "notiBody": notiBody,
            "createdAt": serverDate,
          });
        } else if (mode == "edit") {
        await FirebaseFirestore.instance
          .collection("notitemplates")
          .doc(notiTemplateId)
          .update({
            "notiTemplateId": notiTemplateId,
            "notiTitle": notiTitle,
            "notiBody": notiBody,
            "createdAt": serverDate,
          });
          
        }

        return _fetchNotiTemplates();
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

///
@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@riverpod
Stream<List<NotiTemplate>> notiTemplateStream(NotiTemplateStreamRef ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
    .collection('notitemplates')
//    .where("isOnline", isEqualTo: false)
    .orderBy('createdAt', descending: false)
//    .orderBy('createdAt', descending: true)
    .withConverter<NotiTemplate?>(fromFirestore:  (ds, _) {
      final data = ds.data();
      final id = ds.id;

      if (data == null) {
        return null;
      }
      data['id'] = id;
      return NotiTemplate.fromJson(data);
    }, toFirestore: (template, _) {
      return template?.toJson() ?? {};
    })
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => doc.data()).whereType<NotiTemplate>().toList());
}
