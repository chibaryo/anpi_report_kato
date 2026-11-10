import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'me_api_provider.dart';
import 'notifications_api_provider.dart';
import 'office_location_api_provider.dart';
import 'templates_api_provider.dart';
import 'users_api_provider.dart';

void invalidateAccountApiProviders(WidgetRef ref) {
  ref.invalidate(neonMeProvider);
  ref.invalidate(neonNotificationsProvider);
  ref.invalidate(neonOfficeLocationsProvider);
  ref.invalidate(neonUsersProvider);
  ref.invalidate(neonTemplatesProvider);
}
