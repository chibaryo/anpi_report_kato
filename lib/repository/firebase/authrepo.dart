import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> deleteAccount(String uid) async {
    // POST v1 https://anpi-fcm-2024-test.vercel.app/api/firebase/deleteaccount
    const apiUrl = "https://anpi-fcm-2024-test.vercel.app/api/firebase/deleteaccount";
    Uri url = Uri.parse(apiUrl);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = json.encode({'uid': uid});

    http.Response resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      final int statusCode = resp.statusCode;
      print("failed");
      return;
    } else {
      // Ok
      final int statusCode = resp.statusCode;
      print("resp.body: ${resp.body}");

      await _firebaseAuth.signOut();
      print("Account deleted");
    }

  }

  Future<String?> createAccountViaServer(String displayName, String email, String password) async {
    const apiUrl = "https://anpi-fcm-2024-test.vercel.app/api/firebase/createaccount";
    Uri url = Uri.parse(apiUrl);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String body = json.encode(
      {
        'displayName': displayName,
        'email': email,
        'password': password,
      }
    );

    http.Response resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      final int statusCode = resp.statusCode;
      final String result = resp.body;
      return result;
    } else {
      // Ok
      final int statusCode = resp.statusCode;
      final String resultUid = json.decode(resp.body)["result"]["uid"];
      print("resultUid: $resultUid");

      print("Account created");
      return resultUid;
    }
  }
}