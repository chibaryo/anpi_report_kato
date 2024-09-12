import 'package:anpi_report_ios/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;

    if (isAuthenticated) {
      resolver.next(true);
    } else {
      //
      router.replaceAll([const SigninRoute()]);
      resolver.next(false);
    }
  }
}