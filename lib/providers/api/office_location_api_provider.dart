import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/api/app_api_client.dart';
import '../../repository/betterauth/session_repository.dart';

class NeonOfficeLocation {
  const NeonOfficeLocation({
    required this.id,
    required this.displayName,
    required this.sortNumber,
  });

  final String id;
  final String displayName;
  final int sortNumber;
}

final neonOfficeLocationsProvider =
    FutureProvider.autoDispose<List<NeonOfficeLocation>>((ref) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final session = await SessionRepository().readStoredSession();
  if (session == null) {
    return const [];
  }
  final client = AppApiClient(bearerToken: session.bearerToken);
  final response = await client.getJson('/api/app/office-locations');
  final items = response['officeLocations'];
  if (items is! List) {
    return const [];
  }
  return items.whereType<Map>().map((item) {
    return NeonOfficeLocation(
      id: item['id']?.toString() ?? '',
      displayName: item['displayName']?.toString() ?? item['name']?.toString() ?? '',
      sortNumber: int.tryParse(item['sortNumber']?.toString() ?? '') ?? 0,
    );
  }).toList();
});
