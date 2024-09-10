import 'package:anpi_report_ios/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/bottomnav/bottomnav_provider.dart';

@RoutePage()
class TabsRouterScreen extends HookConsumerWidget {
  const TabsRouterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomNavBarVisible = ref.watch(bottomNavNotifierProvider);

    return AutoTabsRouter(
      routes: const [
        AppHomeRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: isBottomNavBarVisible
          ? NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: "home",
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: "settings",
              ),
            ],
            onDestinationSelected: tabsRouter.setActiveIndex,
            backgroundColor: Colors.grey[200],
            indicatorColor: Colors.transparent,
          )
          : null
          ,
        );
      }
    );
  }
}
