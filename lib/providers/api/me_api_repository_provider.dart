import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/api/me_api_repository.dart';

final meApiRepositoryProvider = Provider<MeApiRepository>((ref) {
  return MeApiRepository();
});
