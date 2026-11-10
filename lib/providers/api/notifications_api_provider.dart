import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/api/notifications_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

final notificationsApiRepositoryProvider =
    Provider<NotificationsApiRepository>((ref) {
  return NotificationsApiRepository();
});

final neonNotificationsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(notificationsApiRepositoryProvider);
  return repository.listNotifications();
});
