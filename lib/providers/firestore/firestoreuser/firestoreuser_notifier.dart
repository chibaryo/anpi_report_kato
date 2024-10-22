import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/firestoreuser.dart';

part 'firestoreuser_notifier.g.dart';

@riverpod
class StreamUserNotifier extends  _$StreamUserNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build() async* {
    print("begin retreiving users...");

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

Future<void> deleteUserByUid(String uid) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 1. Delete the user's reports from the notifications collection
    WriteBatch batch = firestore.batch();  // Use a batch to ensure atomic operations

    // Find all reports in the 'notifications' collection where the docId matches the user's uid
    QuerySnapshot reportsSnapshot = await firestore
      .collectionGroup('reports')
      .where('uid', isEqualTo: uid)  // Assuming reports have an 'uid' field
      .get();

    for (DocumentSnapshot doc in reportsSnapshot.docs) {
      batch.delete(doc.reference);  // Queue up the deletion of each report
    }

    // 2. Delete the user's deviceinfo subcollection documents
    QuerySnapshot deviceinfoSnapshot = await firestore
        .collection('users')  // Target the specific user
        .doc(uid)
        .collection('deviceinfo')  // 'deviceinfo' subcollection
        .get();

    for (DocumentSnapshot doc in deviceinfoSnapshot.docs) {
      batch.delete(doc.reference);  // Queue up the deletion
    }

    // 3. Delete the user's profiles subcollection documents
    QuerySnapshot profilesSnapshot = await firestore
        .collection('users')  // Target the specific user
        .doc(uid)
        .collection('profiles')  // 'profiles' subcollection
        .get();

    for (DocumentSnapshot doc in profilesSnapshot.docs) {
      batch.delete(doc.reference);  // Queue up the deletion
    }

    // 4. Finally, delete the user's main document in the 'users' collection
    DocumentReference userDocRef = firestore.collection("users").doc(uid);
    batch.delete(userDocRef);

    // Commit the batch
    await batch.commit();
    
  } catch (e) {
    print("Error deleting user by UID: $e");
    // Handle any errors such as logging or showing user feedback
  }
  }
}
