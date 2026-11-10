import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repository/betterauth/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});

class SessionNotifier extends StateNotifier<AsyncValue<BetterAuthSession?>> {
  SessionNotifier(this._repository) : super(const AsyncValue.data(null));

  final SessionRepository _repository;

  Future<void> restore() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.restoreSession);
  }

  Future<BetterAuthSession> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final session = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      state = AsyncValue.data(session);
      return session;
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncValue.data(null);
  }
}

final sessionNotifierProvider =
    StateNotifierProvider<SessionNotifier, AsyncValue<BetterAuthSession?>>(
  (ref) => SessionNotifier(ref.watch(sessionRepositoryProvider)),
);

final currentSessionProvider = Provider<BetterAuthSession?>((ref) {
  return ref.watch(sessionNotifierProvider).asData?.value;
});
