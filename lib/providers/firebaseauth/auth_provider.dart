import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Firebase Authenticationのインスタンスを生成するプロバイダー
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
// ログイン状態を監視するプロバイダー
final authStateProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
