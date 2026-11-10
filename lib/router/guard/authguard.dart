import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../router/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  static const _storage = FlutterSecureStorage();

  bool get _neonEnabled {
    final raw = dotenv.maybeGet('ENABLE_NEON_DATA_API') ?? 'false';
    return raw.toLowerCase() == 'true' || raw == '1';
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (_neonEnabled) {
      final token = await _storage.read(key: 'betterAuthBearerToken');
      if (token != null && token.isNotEmpty) {
        resolver.next(true);
        return;
      }
      resolver.redirectUntil(const SigninRoute());
      return;
    }

    final isAuth = FirebaseAuth.instance.currentUser != null;
    if (isAuth) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(const SigninRoute());
    }
  }
}
