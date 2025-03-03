
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../router/app_router.dart';
import '../../providers/firebaseauth/auth_provider.dart';

part 'noauthguard.g.dart';

@Riverpod(keepAlive: true)
NoAuthGuard noAuthGuard(Ref ref) {
  return NoAuthGuard(ref: ref);
}

class NoAuthGuard extends AutoRouteGuard {
  Ref ref;
  NoAuthGuard({required this.ref});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    //final isAuth = FirebaseAuth.instance.currentUser != null;
    final isAuth = ref.read(streamAuthNotifierProvider).asData?.value != null;
//    final authState = ref.read(authStateChangesProvider);

    //
    if (isAuth) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const SigninRoute());
    }
  }
}

