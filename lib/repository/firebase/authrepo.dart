import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return result.user?.uid;
    } catch (err) {
      if (err.toString() == '[firebase_auth/invalid-credential] The supplied auth credential is malformed or has expired.') {
        return 'err:malformed_credential';
      }
      if (err.toString() == '[firebase_auth/invalid-email] The email address is badly formatted.') {
        return 'err:email';
      }
      if (err.toString() == '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        return 'err:credential';
      }

    }
    return null;
  }

  Future<String?> createAccountByEmail(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return result.user?.uid;
    } catch (err) {
      //
    }

    return null;
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateProfile(displayName: displayName);
      await _firebaseAuth.currentUser?.reload();
      User? latestUser = _firebaseAuth.currentUser;
      print("latestUser: $latestUser");
      
    } catch (err) {
      //
    }
  }

  Future<void> userReload() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      
    } catch (err) {
      //
    }
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
      await _firebaseAuth.signOut();
  }

}