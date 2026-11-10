import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../betterauth/better_auth_repo.dart';
import '../betterauth/session_repository.dart';

final String apiSrvBaseUrl = dotenv.get('APISRV_BASEURL');

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final BetterAuthRepository _betterAuthRepository = BetterAuthRepository();
  final SessionRepository _sessionRepository = SessionRepository();

  Future<String?> _getIdToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return user.getIdToken(forceRefresh);
  }

  Future<Map<String, String>> _authorizedJsonHeaders() async {
    // Prefer Better Auth bearer when Neon data API is enabled.
    if (SessionRepository.isNeonDataEnabled) {
      final stored = await _sessionRepository.readStoredSession();
      if (stored != null) {
        return {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${stored.bearerToken}',
        };
      }
    }

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
    // Neon/API cutover path: Better Auth only, no Firebase email/password fallback.
    if (SessionRepository.isNeonDataEnabled) {
      final session = await _sessionRepository.signInWithEmail(
        email: email,
        password: password,
      );
      return session.legacyFirebaseUid ?? session.userId;
    }

    if (BetterAuthRepository.isBridgeEnabled) {
      try {
        return await _betterAuthRepository.signInWithBridge(
          email: email,
          password: password,
        );
      } catch (_) {
        // Temporary fallback while migration is incomplete.
      }
    }

    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user?.uid;
    } catch (err) {
      if (err.toString() ==
          '[firebase_auth/invalid-credential] The supplied auth credential is malformed or has expired.') {
        return 'err:malformed_credential';
      }
      if (err.toString() ==
          '[firebase_auth/invalid-email] The email address is badly formatted.') {
        return 'err:email';
      }
      if (err.toString() ==
          '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        return 'err:credential';
      }
    }
    return null;
  }

  Future<String?> restoreSessionWithBiometrics() async {
    if (SessionRepository.isNeonDataEnabled) {
      final session = await _sessionRepository.restoreSession();
      return session?.legacyFirebaseUid ?? session?.userId;
    }
    if (!BetterAuthRepository.isBridgeEnabled) {
      return null;
    }
    try {
      return await _betterAuthRepository.restoreFirebaseSessionFromStoredBearer();
    } catch (_) {
      return null;
    }
  }

  Future<String?> createAccountByEmail(String email, String password) async {
    // Public client signup is disabled in Better Auth cutover.
    if (SessionRepository.isNeonDataEnabled || BetterAuthRepository.isBridgeEnabled) {
      return 'err:signup_disabled';
    }
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
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
    if (SessionRepository.isNeonDataEnabled) {
      await _sessionRepository.signOut();
      try {
        await _firebaseAuth.signOut();
      } catch (_) {
        // Firebase session may already be absent.
      }
      return;
    }
    if (BetterAuthRepository.isBridgeEnabled) {
      await _betterAuthRepository.revokeAndSignOut();
      return;
    }
    await _firebaseAuth.signOut();
  }

  Future<void> deleteAccount(String uid) async {
    final apiUrl = Uri.parse(apiSrvBaseUrl)
        .replace(path: '/api/firebase/deleteaccount')
        .toString();
    final Uri url = Uri.parse(apiUrl);
    final headers = await _authorizedJsonHeaders();
    final String body = json.encode({'uid': uid});

    final http.Response resp =
        await http.post(url, headers: headers, body: body);
    if (resp.statusCode != 200) {
      throw Exception('Failed to delete account');
    }

    await signOut();
  }

  Future<String?> createAccountViaServer(
    String displayName,
    String email,
    String password,
  ) async {
    final apiUrl = Uri.parse(apiSrvBaseUrl)
        .replace(path: '/api/firebase/createaccount')
        .toString();
    final Uri url = Uri.parse(apiUrl);
    final headers = await _authorizedJsonHeaders();
    final String body = json.encode({
      'displayName': displayName,
      'email': email,
      'password': password,
    });

    final http.Response resp =
        await http.post(url, headers: headers, body: body);

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

  Future<http.Response> postAuthorizedJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
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
