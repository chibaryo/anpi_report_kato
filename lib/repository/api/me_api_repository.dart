import 'app_api_client.dart';
import '../betterauth/session_repository.dart';

class MeApiRepository {
  MeApiRepository({
    AppApiClient? apiClient,
    SessionRepository? sessionRepository,
  })  : _apiClient = apiClient ?? AppApiClient(),
        _sessionRepository = sessionRepository ?? SessionRepository();

  final AppApiClient _apiClient;
  final SessionRepository _sessionRepository;

  Future<void> _ensureAuth() async {
    final session = await _sessionRepository.readStoredSession();
    if (session == null) {
      throw Exception('Not authenticated');
    }
    _apiClient.bearerToken = session.bearerToken;
  }

  Future<Map<String, dynamic>> getMe() async {
    await _ensureAuth();
    return _apiClient.getJson('/api/app/me');
  }

  Future<Map<String, dynamic>> patchProfile({
    String? username,
    Map<String, dynamic>? userAttr,
  }) async {
    await _ensureAuth();
    return _apiClient.patchJson('/api/app/me', {
      if (username != null) 'username': username,
      if (userAttr != null) 'userAttr': userAttr,
    });
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
    required String companyCode,
    Map<String, dynamic> userAttr = const {},
  }) {
    return _apiClient.postJson(
      '/api/app/auth/register',
      {
        'email': email,
        'password': password,
        'username': username,
        'companyCode': companyCode,
        'userAttr': userAttr,
      },
      auth: false,
    );
  }

  Future<void> deleteAccount({required String password}) async {
    await _ensureAuth();
    await _apiClient.deleteJson('/api/app/account', {
      'password': password,
    });
  }
}
