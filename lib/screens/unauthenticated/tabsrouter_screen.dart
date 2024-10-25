import 'dart:io';

import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:badges/badges.dart' as badges; // Import the badges package

import '../../providers/bottomnav/bottomnav_provider.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/notification/combined_notification_notifier.dart';

const secureStorage = FlutterSecureStorage();

@RoutePage()
class TabsRouterScreen extends HookConsumerWidget {
  const TabsRouterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomNavBarVisible = ref.watch(bottomNavNotifierProvider);

    final moiUid = useState<String>("");
    final authAsyncValue = ref.watch(authStateChangesProvider);
    final unAnsweredNotiBadgeCount = useState<int>(0);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");
      }

      return () {};
    }, [authAsyncValue]);


    // Wait for authentication to be ready
    if (authAsyncValue.isLoading || authAsyncValue.hasError || moiUid.value.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    // Now it's safe
    final notificationStream = ref.watch(streamNotificationCombinedNotifierProvider(moiUid.value));
    // Count the number of unanswered notis
    notificationStream.whenData((notifications) {
      final unansweredCount = notifications.where((notification) => notification['answered'] == false).length;
      unAnsweredNotiBadgeCount.value = unansweredCount;
    });

    void setIconBadge(int number) async {
      // バッジ表示機能に対応している場合のみ、バッジの数字を更新する
      if (Platform.isIOS) {
        if (await FlutterAppBadger.isAppBadgeSupported()) {
          FlutterAppBadger.updateBadgeCount(number ?? 0); // <-引数の`number`が`null`だった場合は`0`
          // SecureStorageに保存
          await secureStorage.write(key: "currentAppBadgeCount", value: number.toString());
        }
      } else if (Platform.isAndroid) {
        debugPrint("### android number : ${number.toString()}");

        if (await FlutterAppBadger.isAppBadgeSupported()) {
          FlutterAppBadger.updateBadgeCount(number ?? 0); // <-引数の`number`が`null`だった場合は`0`
          // SecureStorageに保存
          await secureStorage.write(key: "currentAppBadgeCount", value: number.toString());
        }
      }
    }

    useEffect(() {
      setIconBadge(unAnsweredNotiBadgeCount.value);
    }, [unAnsweredNotiBadgeCount.value]);

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
            destinations: [
              NavigationDestination(
                icon: 
                unAnsweredNotiBadgeCount.value > 0
                ?
                const Icon(Icons.notifications, size: 36,)
/*                badges.Badge(
                  badgeContent: Text(
                    unAnsweredNotiBadgeCount.value.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  child: const Icon(Icons.notifications, size: 36,),
                ) */
                : const Icon(Icons.notifications, size: 36,)
                ,
                label: "通知",
              ),
              const NavigationDestination(
                icon: Icon(Icons.settings, size: 36,),
                label: "設定",
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
