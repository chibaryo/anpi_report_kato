import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/notification/notification.dart';
import '../../repository/api/notifications_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

class NeonAdminReportView {
  const NeonAdminReportView({required this.reportContents});
  final Map<String, dynamic> reportContents;
}

Map<String, dynamic> _userAttrFromApiRow(Map<String, dynamic> row) {
  final raw = row['user_attr'];
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return <String, dynamic>{};
}

Map<String, dynamic> mapNeonAnsweredReportRow(Map<String, dynamic> row) {
  final answers = row['answers'];
  final contents = answers is Map
      ? Map<String, dynamic>.from(answers)
      : <String, dynamic>{};
  return {
    'report': NeonAdminReportView(reportContents: contents),
    'user': {
      'username': row['username']?.toString() ?? '',
      'email': row['email']?.toString() ?? '',
    },
    'profile': {
      'userAttr': _userAttrFromApiRow(row),
    },
  };
}

Map<String, dynamic> mapNeonUnansweredUserRow(Map<String, dynamic> row) {
  return {
    'user': {
      'username': row['username']?.toString() ?? '',
      'email': row['email']?.toString() ?? '',
    },
    'profile': {
      'userAttr': _userAttrFromApiRow(row),
    },
  };
}

final notificationsApiRepositoryProvider =
    Provider<NotificationsApiRepository>((ref) {
  return NotificationsApiRepository();
});

DateTime? _parseDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

Noti _notiFromNeonRow(Map<String, dynamic> row) {
  final payload = row['payload'];
  final payloadMap = payload is Map ? Map<String, dynamic>.from(payload) : const <String, dynamic>{};
  final typeRaw = payloadMap['notiType'] ?? payloadMap['type'] ?? 0;
  return Noti(
    notificationId: row['id']?.toString() ?? '',
    notiTitle: row['title']?.toString() ?? payloadMap['notiTitle']?.toString() ?? '',
    notiBody: row['body']?.toString() ?? payloadMap['notiBody']?.toString() ?? '',
    notiType: typeRaw is int ? typeRaw : int.tryParse(typeRaw.toString()) ?? 0,
    notiTopic: row['noti_topic']?.toString() ?? payloadMap['notiTopic']?.toString() ?? '',
    createdAt: _parseDate(row['created_at']),
    updatedAt: _parseDate(row['updated_at']),
  );
}

final neonNotificationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(notificationsApiRepositoryProvider);
  final rows = await repository.listNotifications();
  return rows
      .map((row) {
        final noti = _notiFromNeonRow(row);
        return {
          'noti': noti,
          'docId': noti.notificationId,
          'answered': row['answered'] == true,
        };
      })
      .toList();
});

final neonNotificationReportsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, notiId) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(notificationsApiRepositoryProvider);
  final rows = await repository.listReports(notiId);
  return rows.map(mapNeonAnsweredReportRow).toList();
});

final neonNotificationUnansweredProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, notiId) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(notificationsApiRepositoryProvider);
  final rows = await repository.listUnanswered(notiId);
  return rows.map(mapNeonUnansweredUserRow).toList();
});
