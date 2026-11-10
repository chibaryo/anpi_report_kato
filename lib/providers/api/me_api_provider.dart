import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile.dart';
import '../../repository/api/app_api_client.dart';
import '../../repository/betterauth/session_repository.dart';

final neonMeProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final session = await SessionRepository().readStoredSession();
  if (session == null) {
    throw Exception('Not authenticated');
  }
  final client = AppApiClient(bearerToken: session.bearerToken);
  return client.getJson('/api/app/me');
});

final neonMoiProfileProvider = Provider<AsyncValue<Profile?>>((ref) {
  final me = ref.watch(neonMeProvider);
  return me.whenData((value) {
    final user = value['user'];
    final access = value['access'];
    if (user is! Map) {
      return null;
    }
    final userAttr = user['user_attr'] is Map
        ? Map<String, dynamic>.from(user['user_attr'] as Map)
        : <String, dynamic>{};
    if (access is Map && access['role'] != null && userAttr['jobLevel'] == null) {
      final role = access['role']?.toString();
      userAttr['jobLevel'] = switch (role) {
        'developer' => 8,
        'admin' => 4,
        'leader' => 2,
        _ => 0,
      };
    }
    return Profile(
      uid: user['legacy_firebase_uid']?.toString() ?? user['id']?.toString() ?? '',
      userAttr: userAttr,
    );
  });
});
