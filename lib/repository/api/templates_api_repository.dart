import 'app_api_client.dart';
import '../betterauth/session_repository.dart';

class TemplatesApiRepository {
  TemplatesApiRepository({
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

  Future<List<Map<String, dynamic>>> listTemplates() async {
    await _ensureAuth();
    final response = await _apiClient.getJson('/api/app/templates');
    final items = response['templates'];
    if (items is List) {
      return items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> createTemplate(Map<String, dynamic> body) async {
    await _ensureAuth();
    return _apiClient.postJson('/api/app/templates', body);
  }

  Future<Map<String, dynamic>> updateTemplate(
    String id,
    Map<String, dynamic> body,
  ) async {
    await _ensureAuth();
    return _apiClient.patchJson('/api/app/templates/$id', body);
  }

  Future<void> deleteTemplate(String id) async {
    await _ensureAuth();
    await _apiClient.deleteJson('/api/app/templates/$id', {});
  }
}
