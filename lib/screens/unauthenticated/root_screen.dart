import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../router/app_router.dart';

@RoutePage()
class RootScreen extends HookConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // https://zenn.dev/joo_hashi/articles/b2e47eaa592f3a
    ref.listen(streamAuthNotifierProvider, (previous, next) {
      // Check the current route
      final currentRoute = context.router.current.name;

      if (currentRoute == RootRoute.name) {
        if (next.asData?.value != null) {
          context.router.replace(const AppHomeRoute());
        } else {
          // If not logged in
          context.router.replace(const SigninRoute());
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: const Center(
//          child: CircularProgressIndicator(),
          child: Text("Root!")
        )
    );
  }
}
