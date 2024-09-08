import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}
/// [認証状態を監視するプロバイダー]
@riverpod
class StreamAuthNotifier extends _$StreamAuthNotifier {
  @override
  Stream<User?> build() async* {
    yield* authStateChangeFunction();
  }

  Stream<User?> authStateChangeFunction() async* {
    yield* ref.read(firebaseAuthProvider).authStateChanges();
  }
}

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});