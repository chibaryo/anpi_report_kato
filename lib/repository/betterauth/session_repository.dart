import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/app_api_client.dart';
import 'better_auth_repo.dart';

const _bearerStorageKey = 'betterAuthBearerToken';
const _emailStorageKey = 'betterAuthUserEmail';
const _userIdStorageKey = 'betterAuthUserId';

class BetterAuthSession {
  const BetterAuthSession({
    required this.userId,
    required this.email,
    required this.bearerToken,
    this.username,
    this.role,
    this.legacyFirebaseUid,
  });

  final String userId;
  final String email;
  final String bearerToken;
  final String? username;
  final String? role;
  final String? legacyFirebaseUid;
}

class SessionRepository {
  SessionRepository({
    FlutterSecureStorage? storage,
    AppApiClient? apiClient,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _apiClient = apiClient ?? AppApiClient();

  final FlutterSecureStorage _storage;
  final AppApiClient _apiClient;

  static bool get isNeonDataEnabled {
    final raw = dotenv.maybeGet('ENABLE_NEON_DATA_API') ?? 'false';
    return raw.toLowerCase() == 'true' || raw == '1';
  }

  static bool get isBridgeEnabled => BetterAuthRepository.isBridgeEnabled;

  Future<BetterAuthSession?> readStoredSession() async {
    final token = await _storage.read(key: _bearerStorageKey);
    final email = await _storage.read(key: _emailStorageKey);
    final userId = await _storage.read(key: _userIdStorageKey);
    if (token == null || token.isEmpty || email == null || userId == null) {
      return null;
    }
    return BetterAuthSession(
      userId: userId,
      email: email,
      bearerToken: token,
    );
  }

  Future<void> _persist({
    required String bearerToken,
    required String email,
    required String userId,
  }) async {
    await _storage.write(key: _bearerStorageKey, value: bearerToken);
    await _storage.write(key: _emailStorageKey, value: email);
    await _storage.write(key: _userIdStorageKey, value: userId);
  }

  Future<void> clear() async {
    await _storage.delete(key: _bearerStorageKey);
    await _storage.delete(key: _emailStorageKey);
    await _storage.delete(key: _userIdStorageKey);
  }

  Future<BetterAuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.postJson(
      '/api/app/auth/sign-in',
      {
        'email': email,
        'password': password,
      },
      auth: false,
    );

    final token = response['token'] as String?;
    final user = response['user'];
    if (token == null || token.isEmpty || user is! Map) {
      throw Exception('Better Auth sign-in failed');
    }
    final userId = user['id']?.toString();
    final userEmail = user['email']?.toString() || email;
    if (userId == null || userId.isEmpty) {
      throw Exception('Better Auth user id missing');
    }

    await _persist(bearerToken: token, email: userEmail, userId: userId);
    _apiClient.bearerToken = token;

    final me = await _apiClient.getJson('/api/app/me');
    final appUser = me['user'];
    final access = me['access'];

    return BetterAuthSession(
      userId: userId,
      email: userEmail,
      bearerToken: token,
      username: appUser is Map ? appUser['username']?.toString() : null,
      role: access is Map ? access['role']?.toString() : user['role']?.toString(),
      legacyFirebaseUid:
          appUser is Map ? appUser['legacy_firebase_uid']?.toString() : null,
    );
  }

  Future<BetterAuthSession?> restoreSession() async {
    final stored = await readStoredSession();
    if (stored == null) return null;
    _apiClient.bearerToken = stored.bearerToken;
    try {
      final me = await _apiClient.getJson('/api/app/me');
      final appUser = me['user'];
      final access = me['access'];
      return BetterAuthSession(
        userId: stored.userId,
        email: stored.email,
        bearerToken: stored.bearerToken,
        username: appUser is Map ? appUser['username']?.toString() : null,
        role: access is Map ? access['role']?.toString() : null,
        legacyFirebaseUid:
            appUser is Map ? appUser['legacy_firebase_uid']?.toString() : null,
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> signOut() async {
    final stored = await readStoredSession();
    if (stored != null) {
      try {
        await _apiClient.postJson('/api/auth/sign-out', {});
      } catch (_) {
        // Always clear local session.
      }
    }
    await clear();
  }

  Future<void> registerDevice({
    required String udid,
    required String platform,
    required String? fcmToken,
    List<String> topics = const [],
  }) async {
    final stored = await readStoredSession();
    if (stored == null) return;
    _apiClient.bearerToken = stored.bearerToken;
    await _apiClient.postJson('/api/app/devices', {
      'udid': udid,
      'platform': platform,
      'fcmToken': fcmToken,
      'topics': topics,
    });
  }

  Future<bool> isAppOutdated({
    required String version,
    required int build,
  }) async {
    final result = await _apiClient.postJson(
      '/api/app/min-version',
      {
        'version': version,
        'build': build,
      },
      auth: false,
    );
    return result['outdated'] == true;
  }
}
