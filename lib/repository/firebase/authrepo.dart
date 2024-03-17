import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> signIn(String emailAddr, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddr,
        password: password
      );
      return result.user?.uid;
    } catch (err) {
//      print("err : $err");
      if (err.toString() == '[firebase_auth/invalid-email] The email address is badly formatted.') {
        return 'err:email';
      }
      if (err.toString() == '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        return 'err:credential';
      }

    }
    return null;
  }

}
