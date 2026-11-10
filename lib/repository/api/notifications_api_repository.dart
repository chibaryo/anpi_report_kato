import 'app_api_client.dart';
import '../betterauth/session_repository.dart';

class NotificationsApiRepository {
  NotificationsApiRepository({
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

  Future<List<Map<String, dynamic>>> listNotifications({
    int limit = 100,
    int offset = 0,
  }) async {
    await _ensureAuth();
    final response = await _apiClient.getJson(
      '/api/app/notifications',
      query: {
        'limit': '$limit',
        'offset': '$offset',
      },
    );
    final items = response['notifications'];
    if (items is List) {
      return items.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> submitReport({
    required String notificationId,
    required Map<String, dynamic> answers,
  }) async {
    await _ensureAuth();
    return _apiClient.postJson(
      '/api/app/notifications/$notificationId/reports',
      {'answers': answers},
    );
  }

  Future<List<Map<String, dynamic>>> listUnanswered(String notificationId) async {
    await _ensureAuth();
    final response = await _apiClient.getJson(
      '/api/app/notifications/$notificationId/unanswered',
    );
    final items = response['users'];
    if (items is List) {
      return items.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> sendToTopic(Map<String, dynamic> payload) async {
    await _ensureAuth();
    return _apiClient.postJson('/api/app/send-to-topic', payload);
  }
}
