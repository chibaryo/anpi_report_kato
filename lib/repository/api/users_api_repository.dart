import 'app_api_client.dart';
import '../betterauth/session_repository.dart';

class UsersApiRepository {
  UsersApiRepository({
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

  Future<List<Map<String, dynamic>>> listUsers({
    int limit = 200,
    int offset = 0,
  }) async {
    await _ensureAuth();
    final response = await _apiClient.getJson(
      '/api/app/users',
      query: {
        'limit': '$limit',
        'offset': '$offset',
      },
    );
    final items = response['users'];
    if (items is List) {
      return items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> body) async {
    await _ensureAuth();
    return _apiClient.postJson('/api/app/users/create', body);
  }

  Future<Map<String, dynamic>> updateUser(
    String id,
    Map<String, dynamic> body,
  ) async {
    await _ensureAuth();
    return _apiClient.patchJson('/api/app/users/$id', body);
  }

  Future<void> deleteUser(String id, {String reason = 'admin_deleted'}) async {
    await _ensureAuth();
    await _apiClient.deleteJson('/api/app/users/$id', {'reason': reason});
  }
}
