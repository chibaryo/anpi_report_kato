import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/firebaseuser.dart';

part 'user_provider.g.dart';

@riverpod
class AsyncFirebaseUserNotifier extends _$AsyncFirebaseUserNotifier {
  Future<List<FirebaseUser>> _fetchFirebaseUsers() async {
    final snapshots = await FirebaseFirestore.instance.collection('users').get();
    // データ(Map型)を取得
    return snapshots.docs.map((doc) => FirebaseUser.fromJson(doc.data())).toList();
  }

  @override
  FutureOr<List<FirebaseUser>> build() async {
    return _fetchFirebaseUsers();
  }

  // Get one
  Future<FirebaseUser?> getFirebaseUserById (String uid) async {
    final doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .get();
    
    if (doc.exists) {
      return FirebaseUser.fromJson(doc.data()!);
    } else {
      return null;
    }
  }

  // CREATE(Add)
  Future<void> addFirebaseUser({
    required String name,
    required String email,
    required String password,
    required String imagepath,
    bool? isAdmin,
    }) async {
    final serverDate = DateTime.now();

    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {
        // CreateUser on Firebase
        final result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Patch /w displayName
        await result.user!.updateDisplayName(name);

        // Add to firestore
        await FirebaseFirestore.instance
          .collection("users")
          .doc(result.user?.uid)
          .set({
            "uid": result.user?.uid,
            "name": name,
            "email": email,
            "password": password,
            "imagepath": imagepath,
            "isAdmin": isAdmin,
            "createdAt": serverDate,
          });
        return _fetchFirebaseUsers();
      } catch (err) {
        throw Exception(err);
      }
    });
  }

  Future<void> toggleFirebaseUserOnlineStatus({
    required String uid,
    required bool isOnlineStatus
  }) async {
    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {
        await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({
            "isOnline": isOnlineStatus
          });
        return _fetchFirebaseUsers();
      } catch (err) {
        throw Exception(err);
      }
    });
  }

    Future<void> updateFirebaseUserDisplayName({
      required String uid,
      required String name,
    }) async {
    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {
        // CreateUser on Firebase
        await FirebaseAuth.instance
        .currentUser!.updateDisplayName(
          name
        );

        // Add to firestore
        await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({
            "name": name,
//            "updatedAt": serverDate,
          });
        return _fetchFirebaseUsers();
      } catch (err) {
        throw Exception(err);
      }
    });
  }

    Future<void> updateFirebaseUserPassword({
      required String uid,
      required String password,
    }) async {

    // Set the state to loading
    state = const AsyncValue.loading();
    // Add the new FirebaseUser and reload the FirebaseUser list from the remote repository
    state = await AsyncValue.guard(() async {
      try {
        // CreateUser on Firebase
        await FirebaseAuth.instance
        .currentUser!.updatePassword(
          password
        );

        // Add to firestore
        await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({
            "password": password,
//            "updatedAt": serverDate,
          });
        return _fetchFirebaseUsers();
      } catch (err) {
        throw Exception(err);
      }
    });
  }

}

final sitecodeProvider = StateProvider<int>((ref) => 0);