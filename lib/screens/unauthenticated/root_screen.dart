import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../router/app_router.dart';

@RoutePage()
class RootScreen extends HookConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(streamAuthNotifierProvider, (previous, next) {
      // Check the current route
      final currentRoute = context.router.current.name;

      if (currentRoute == RootRoute.name) {
        if (next.asData?.value != null) {
          context.router.replace(const TabsRouterRoute());
        } else {
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
          child: CircularProgressIndicator(),
        )
    );
  }
}
