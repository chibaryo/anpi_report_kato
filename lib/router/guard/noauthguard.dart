
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../router/app_router.dart';

class NoAuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuth = FirebaseAuth.instance.currentUser != null;

    //
    if (!isAuth) {
      resolver.next(true);
    } else {
      router.replaceAll([const TabsRouterRoute()]);
      resolver.next(false);
    }
  }
}

