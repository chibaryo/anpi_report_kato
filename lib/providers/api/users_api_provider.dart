import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/firestoreuser.dart';
import '../../repository/api/users_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

final usersApiRepositoryProvider = Provider<UsersApiRepository>((ref) {
  return UsersApiRepository();
});

Map<String, dynamic> _userAttrFromRow(Map<String, dynamic> row) {
  final raw = row['user_attr'];
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return <String, dynamic>{};
}

Map<String, dynamic> _mapNeonUserRow(Map<String, dynamic> row) {
  final id = row['id']?.toString() ?? row['legacy_firebase_uid']?.toString() ?? '';
  return {
    'user': FirestoreUser(
      username: row['username']?.toString() ?? '',
      email: row['email']?.toString() ?? '',
    ),
    'profile': {
      'uid': id,
      'userAttr': _userAttrFromRow(row),
    },
  };
}

final neonUsersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(usersApiRepositoryProvider);
  final rows = await repository.listUsers();
  return rows.map(_mapNeonUserRow).toList();
});
