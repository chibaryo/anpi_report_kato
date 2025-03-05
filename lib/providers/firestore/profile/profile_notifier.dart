import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/profile.dart';

part 'profile_notifier.g.dart';

@riverpod
class StreamProfileNotifier extends  _$StreamProfileNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    yield* FirebaseFirestore.instance
      .collectionGroup("profiles")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
        final profile = Profile.fromJson(doc.data());
        return {
          'profile': profile,
          'docId': doc.id,
        };
      }).toList());
  }

  // Get a profile by UID
  Future<Profile?> getProfileByUid(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("profiles")
        .doc(uid)
        .get();
    
      if (doc.exists) {
        return Profile.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }


  // Add a new record
  Future<void> addProfile(String uid, Profile profile) async {
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("profiles")
        .doc(uid)
        .set(profile.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update profile
  Future<void> updateProfileByUid(String uid, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("profiles")
        .doc(uid)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

}
