import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../router/app_router.dart';

//part 'authguard.g.dart';

/*@Riverpod(keepAlive: true)
AuthGuard authGuard(Ref ref) {
  return AuthGuard(ref: ref);
}
*/

class AuthGuard extends AutoRouteGuard {
/*  Ref ref;
  AuthGuard({required this.ref});
*/
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuth = FirebaseAuth.instance.currentUser != null;
//    final isAuth = ref.read(streamAuthNotifierProvider).asData?.value != null;
//    final authState = ref.read(authStateChangesProvider);

    //
    if (isAuth) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(SigninRoute());
    }
  }
}

