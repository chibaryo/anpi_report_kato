import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../progress/progress_notifier.dart';


part 'unanswereduserlist_notifier.g.dart';

final firestore = FirebaseFirestore.instance;
late final FirestoreCache usersCache;

@riverpod
Future<List<Map<String, dynamic>>> fetchUnansweredUsers(Ref ref, String notiId) async {
  const cacheField = 'updatedAt'; // Field used for caching
  final cacheDocRef = firestore.doc('cachestatus/users'); // Cache document reference
  final query = firestore.collection("users");

  final usersCache = await FirestoreCache.getDocuments(
    query: query,
    cacheDocRef: cacheDocRef,
    firestoreCacheField: cacheField
  );

  final allUserUids = usersCache.docs.map((doc) => doc.id).toList();

  final ureportsSnapshot = await firestore
      .collection("notifications")
      .doc(notiId)
      .collection("ureports")
      .get();

  final reportedUserUids = ureportsSnapshot.docs.map((doc) => doc.id).toList(); // Fix: Use `docs` property

  // Step 4: Find users who did not send a report (unanswered users)
  final unansweredUserUids = allUserUids.where((uid) => !reportedUserUids.contains(uid)).toList();

  // Step 5: Fetch user and profile data for unanswered users
  final List<Map<String, dynamic>> unansweredUsersData = [];
  int processedUsers = 0; // Track the number of processed users
  final totalUnansweredUsers = unansweredUserUids.length; // Total number of unanswered users

  for (final uid in unansweredUserUids) {
    // Fetch user data
    final userDoc = await firestore.collection("users").doc(uid).get();
    final user = userDoc.data();

    // Fetch profile data
    final profileDoc = await firestore
        .collection("users")
        .doc(uid)
        .collection("profiles")
        .doc(uid)
        .get();
    final profile = profileDoc.data();

    if (user != null && profile != null) {
      unansweredUsersData.add({
        'user': user,
        'profile': profile,
      });
    }

      processedUsers++;
      final progress = processedUsers / totalUnansweredUsers;
      ref.read(progressNotifierProvider.notifier).updateProgress(progress);

  }

  // Step 6: Return the unanswered users data
  return unansweredUsersData;
}
/*
class StreamUnansweredUserNotifier extends _$StreamUnansweredUserNotifier {
  @override
  Stream<List<Map<String, dynamic>>> build(String notiId) async* {
    const cacheField = 'updatedAt'; // Field used for caching
    final cacheDocRef = firestore.doc('cachestatus/users'); // Cache document reference
    final query = firestore.collection("users");

    final usersCache = await FirestoreCache.getDocuments(
      query: query,
      cacheDocRef: cacheDocRef,
      firestoreCacheField: cacheField
    );

    yield* FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .asyncMap((usersSnapshot) async {
        // Step 1: Get all user IDs
        final allUserUids = usersSnapshot.docs.map((doc) => doc.id).toList();

        // Step 2: Get all reported user IDs for the specific notification
        final ureportsSnapshot = await FirebaseFirestore.instance
          .collection("notifications")
          .doc(notiId)
          .collection("ureports")
          .get();
        final reportedUserUids = ureportsSnapshot.docs.map((doc) => doc.id).toList();

        // Step 3: Find users who did not send a report
        final unansweredUserUids = allUserUids.where((uid) => !reportedUserUids.contains(uid)).toList();

        // Step 4: Fetch user and profile data for unanswered users
        final List<Map<String, dynamic>> unansweredUsersData = [];
        int processedUsers = 0; // Track the number of processed users
        final totalUnansweredUsers = unansweredUserUids.length; // Total number of unanswered users

        for (final uid in unansweredUserUids) {
          // Fetch user data
          final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get();
          final user = userDoc.data();

          // Fetch profile data
          final profileDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("profiles")
            .doc(uid)
            .get();
          final profile = profileDoc.data();

          if (user != null && profile != null) {
            unansweredUsersData.add({
              'user': user,
              'profile': profile,
            });
          }

          processedUsers++;
          final progress = processedUsers / totalUnansweredUsers;
          ref.read(progressNotifierProvider.notifier).updateProgress(progress);

        }

        return unansweredUsersData;
      });
  }
} */