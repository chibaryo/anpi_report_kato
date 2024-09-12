import 'package:anpi_report_ios/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoAuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;

    if (isAuthenticated) {
      router.replaceAll([const TabsRouterRoute()]);
      resolver.next(false);
    } else {
      //
      router.replaceAll([const SigninRoute()]);
      resolver.next(false);
    }
  }
}

/*
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../router/app_router.dart';
import '../../providers/firebaseauth/auth_provider.dart';

part 'noauthguard.g.dart';

@Riverpod(keepAlive: true)
NoAuthGuard noAuthGuard(NoAuthGuardRef ref) {
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
      // If logged in, skip Signin
      resolver.redirect(const SignupRoute());
    } else {
      resolver.redirect(const SignupRoute());
      // If not logged in, goto Signin
      // resolver.next(true);
    }
  }
}
*/

