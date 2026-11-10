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

  List<Map<String, dynamic>> _asMapList(dynamic items) {
    if (items is List) {
      return items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
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
    return _asMapList(response['notifications']);
  }

  Future<Map<String, dynamic>?> getNotification(String notificationId) async {
    await _ensureAuth();
    final response =
        await _apiClient.getJson('/api/app/notifications/$notificationId');
    final notification = response['notification'];
    if (notification is Map) {
      return Map<String, dynamic>.from(notification);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getMyReport(String notificationId) async {
    await _ensureAuth();
    final response = await _apiClient
        .getJson('/api/app/notifications/$notificationId/reports/me');
    final report = response['report'];
    if (report is Map) {
      return Map<String, dynamic>.from(report);
    }
    return null;
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

  Future<List<Map<String, dynamic>>> listReports(String notificationId) async {
    await _ensureAuth();
    final response = await _apiClient
        .getJson('/api/app/notifications/$notificationId/reports');
    return _asMapList(response['reports']);
  }

  Future<List<Map<String, dynamic>>> listUnanswered(
      String notificationId) async {
    await _ensureAuth();
    final response = await _apiClient
        .getJson('/api/app/notifications/$notificationId/unanswered');
    return _asMapList(response['users']);
  }

  Future<Map<String, dynamic>> sendToTopic(Map<String, dynamic> payload) async {
    await _ensureAuth();
    return _apiClient.postJson('/api/app/send-to-topic', payload);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _ensureAuth();
    await _apiClient.deleteJson('/api/app/notifications/$notificationId', {});
  }
}
