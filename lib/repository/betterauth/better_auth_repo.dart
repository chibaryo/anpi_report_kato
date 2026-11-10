import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const _bearerStorageKey = 'betterAuthBearerToken';
const _emailStorageKey = 'betterAuthUserEmail';

class BetterAuthRepository {
  BetterAuthRepository({
    FlutterSecureStorage? storage,
    FirebaseAuth? firebaseAuth,
    http.Client? httpClient,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _httpClient = httpClient ?? http.Client();

  final FlutterSecureStorage _storage;
  final FirebaseAuth _firebaseAuth;
  final http.Client _httpClient;

  static bool get isBridgeEnabled {
    final raw = dotenv.maybeGet('ENABLE_BETTER_AUTH_BRIDGE') ?? 'false';
    return raw.toLowerCase() == 'true' || raw == '1';
  }

  Uri _apiUri(String path) {
    final base = dotenv.get('APISRV_BASEURL');
    return Uri.parse(base).replace(path: path);
  }

  Future<String?> readStoredBearerToken() => _storage.read(key: _bearerStorageKey);

  Future<void> clearStoredSession() async {
    await _storage.delete(key: _bearerStorageKey);
    await _storage.delete(key: _emailStorageKey);
  }

  Future<void> _persistSession({
    required String bearerToken,
    required String email,
  }) async {
    await _storage.write(key: _bearerStorageKey, value: bearerToken);
    await _storage.write(key: _emailStorageKey, value: email);
  }

  Future<String> _signInBetterAuth({
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post(
      _apiUri('/api/auth/sign-in/email'),
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Better Auth sign-in failed');
    }

    final bearer = response.headers['set-auth-token'];
    if (bearer == null || bearer.isEmpty) {
      // Some deployments expose the token in JSON body as well.
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final token = decoded is Map ? decoded['token'] : null;
      if (token is! String || token.isEmpty) {
        throw Exception('Better Auth bearer token missing');
      }
      return token;
    }
    return bearer;
  }

  Future<String> _fetchFirebaseCustomToken(String bearerToken) async {
    final response = await _httpClient.post(
      _apiUri('/api/auth/firebase-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Firebase custom token');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final customToken = decoded is Map ? decoded['customToken'] : null;
    if (customToken is! String || customToken.isEmpty) {
      throw Exception('Invalid firebase-token response');
    }
    return customToken;
  }

  Future<String?> signInWithBridge({
    required String email,
    required String password,
  }) async {
    final bearerToken = await _signInBetterAuth(email: email, password: password);
    final customToken = await _fetchFirebaseCustomToken(bearerToken);
    final credential = await _firebaseAuth.signInWithCustomToken(customToken);
    await _persistSession(bearerToken: bearerToken, email: email);
    return credential.user?.uid;
  }

  Future<String?> restoreFirebaseSessionFromStoredBearer() async {
    final bearerToken = await readStoredBearerToken();
    if (bearerToken == null || bearerToken.isEmpty) {
      return null;
    }

    final customToken = await _fetchFirebaseCustomToken(bearerToken);
    final credential = await _firebaseAuth.signInWithCustomToken(customToken);
    return credential.user?.uid;
  }

  Future<void> revokeAndSignOut() async {
    final bearerToken = await readStoredBearerToken();
    if (bearerToken != null && bearerToken.isNotEmpty) {
      try {
        await _httpClient.post(
          _apiUri('/api/auth/revoke-bridge'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
        );
      } catch (_) {
        // Always continue local sign-out.
      }
    }

    await clearStoredSession();
    await _firebaseAuth.signOut();
  }
}
