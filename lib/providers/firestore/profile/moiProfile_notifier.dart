import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/profile.dart';

part 'moiProfile_notifier.g.dart';

@riverpod
class StreamMoiProfileNotifier extends  _$StreamMoiProfileNotifier {
  @override
  Stream<Profile?> build(String uid) async* {
    yield* FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("profiles")
      .doc(uid)
      .snapshots()
      .map((docSnap) {
        if (docSnap.exists) {
          return Profile.fromJson(docSnap.data()!);
        } else {
          return null;
        }
      });
  }
}
