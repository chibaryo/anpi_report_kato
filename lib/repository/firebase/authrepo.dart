import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiSrvBaseUrl = dotenv.get('APISRV_BASEURL');

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _getIdToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return user.getIdToken(forceRefresh);
  }

  Future<Map<String, String>> _authorizedJsonHeaders() async {
    final idToken = await _getIdToken();
    if (idToken == null) {
      throw Exception('Not authenticated');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    };
  }

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
    final apiUrl = Uri.parse(apiSrvBaseUrl).replace(path: '/api/firebase/deleteaccount').toString();
    final Uri url = Uri.parse(apiUrl);
    final headers = await _authorizedJsonHeaders();
    final String body = json.encode({'uid': uid});

    final http.Response resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Failed to delete account');
    }

    await _firebaseAuth.signOut();
  }

  Future<String?> createAccountViaServer(String displayName, String email, String password) async {
    final apiUrl = Uri.parse(apiSrvBaseUrl).replace(path: '/api/firebase/createaccount').toString();
    final Uri url = Uri.parse(apiUrl);
    final headers = await _authorizedJsonHeaders();
    final String body = json.encode(
      {
        'displayName': displayName,
        'email': email,
        'password': password,
      }
    );

    final http.Response resp = await http.post(url, headers: headers, body: body);

    if (resp.statusCode != 200) {
      return resp.body;
    }

    final decoded = json.decode(resp.body);
    final resultUid = decoded["result"]?["uid"];
    if (resultUid is! String || resultUid.isEmpty) {
      throw Exception('Invalid createaccount response');
    }

    return resultUid;
  }

  Future<http.Response> postAuthorizedJson(String path, Map<String, dynamic> payload) async {
    final apiUrl = Uri.parse(apiSrvBaseUrl).replace(path: path).toString();
    final Uri url = Uri.parse(apiUrl);
    final headers = await _authorizedJsonHeaders();
    return http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );
  }
}
