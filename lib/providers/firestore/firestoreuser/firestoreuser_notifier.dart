import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/firestoreuser.dart';

part 'firestoreuser_notifier.g.dart';

@riverpod
class StreamUserNotifier extends  _$StreamUserNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    // Create a stream for user documents
    final userStream = FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .asyncMap((userSnapshot) async {
        // Fetch user data and their profiles in parallel
        final userDocs = userSnapshot.docs;
        
        // Retrieve user documents and their profiles
        final userProfilesFutures = userDocs.map((userDoc) async {
          // Fetch user data
          final user = FirestoreUser.fromJson(userDoc.data());
          
          // Fetch the profile data for this user
          final profileSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(userDoc.id)
            .collection("profiles")
            .doc(userDoc.id)
            .get();
          
          final profileData = profileSnapshot.data();
          
          return {
            'user': user,
            'profile': profileData,
            'docId': userDoc.id,
          };
        }).toList();
        
        // Wait for all profile fetches to complete
        final userProfiles = await Future.wait(userProfilesFutures);
        
        return userProfiles;
      });
      
    // Yield the combined stream
    yield* userStream;
  }

  // Get a user
  Future<FirestoreUser?> getUserByUid(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

      if (doc.exists) {
        return FirestoreUser.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (err) {
      //
      return null;
    }
  }

  // Add a new record
  Future<void> addUser(String uid, FirestoreUser user) async {
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(user.toJson());
    } catch (e) {
      // Handle any errors here, such as logging
    }
  }

  // Update user
  Future<void> updateUserByUid(String uid, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(updates, SetOptions(merge: true));
    } catch (e) {
      //
    }
  }
}