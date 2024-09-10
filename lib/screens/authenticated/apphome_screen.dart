import 'package:anpi_report_ios/providers/bottomnav/bottomnav_provider.dart';
import 'package:anpi_report_ios/providers/firestore/notification/notifications_answered_byme_notifier.dart';
import 'package:anpi_report_ios/screens/authenticated/postenquete_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/notification/notification.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/notification/combined_notification_notifier.dart';
import '../../router/app_router.dart';

@RoutePage()
class AppHomeRouterScreen extends AutoRouter {
  const AppHomeRouterScreen({super.key});
}

@RoutePage()
class AppHomeScreen extends HookConsumerWidget {
  const AppHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final tabController = useTabController(initialLength: 2);
    final authAsyncValue = ref.watch(authStateChangesProvider);
    //final answeredByMeNotificationStream = ref.watch(streamNotificationAnswerByMeNotifierProvider(moiUid.value));
    final notificationStream = ref.watch(streamNotificationCombinedNotifierProvider(moiUid.value));

    useEffect(() {
      Future.microtask(() {
        ref.read(
          bottomNavNotifierProvider.notifier
        ).show();
        ref.invalidate(
          streamNotificationCombinedNotifierProvider(moiUid.value)
        );
      });

      return () {};
    }, const []);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");
      }

      return () {};
    }, [authAsyncValue]);
    
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: "未回答"),
                Tab(text: "回答済み"),
              ],
            ),
            // TabBarView
            Expanded(
              child: 
                notificationStream.asData?.value != null && notificationStream.asData!.value.isNotEmpty
                ?
                TabBarView(
                  controller: tabController,
                  children: [
                  Center(
                    child: switch(notificationStream) {
                      AsyncData(:final value) =>
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: value.length,
                                  (BuildContext context, int index) {
                                    final notiMap = value[index];
                                    final noti = notiMap["noti"] as Noti;
                                    final answered = notiMap["answered"] as bool;

                                    // Filter only answered notifications
                                    if (answered) {
                                      return const SizedBox.shrink(); // Skip un-answered notifications
                                    }
                                    //                                    final docId = notiMap["docId"].toString();
                                    //debugPrint("notiMap: ${notiMap.toString()}");
                                    debugPrint("length");

                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        onTap: () async {
                                          // Go to PostEnqueteRoute
                                          if (context.mounted) {
                                            await context.router.push(PostEnqueteRoute(notificationId: noti.notificationId));
                                            ref.read(bottomNavNotifierProvider.notifier).show();
                                            // Invalidate list
                                            ref.invalidate(streamNotificationCombinedNotifierProvider(moiUid.value));
                                          }
                                        },
                                        contentPadding: const EdgeInsets.all(4.0),
                                        title: Text(noti.notiTitle), 

                                      ),
                                    );

                                  }
                                )
                              ),
                            ),
                          ],
                        ),
                      AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
                      _ => const Center(child: CircularProgressIndicator()),                      
                    },
                  ),
                  Center(
                    child: switch(notificationStream) {
                      AsyncData(:final value) =>
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: value.length,
                                  (BuildContext context, int index) {
                                    final notiMap = value[index];
                                    final noti = notiMap["noti"] as Noti;
                                    final answered = notiMap["answered"] as bool;

                                    // Filter only answered notifications
                                    if (!answered) {
                                      return const SizedBox.shrink(); // Skip un-answered notifications
                                    }
                                    //                                    final docId = notiMap["docId"].toString();
                                    debugPrint("notiMap: ${notiMap.toString()}");
                                    debugPrint("length");

                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        onTap: () async {
                                            await context.router.push(PostEnqueteRoute(notificationId: noti.notificationId));
                                        },
                                        contentPadding: const EdgeInsets.all(4.0),
                                        title: Text(noti.notiTitle), 

                                      ),
                                    );

                                  }
                                )
                              ),
                            ),
                          ],
                        ),
                      AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
                      _ => const Center(child: CircularProgressIndicator()),                      
                    },
                  )
                ],
              )
              : const Center(child: CircularProgressIndicator()),
            )
          ],
        )
    );
  }
}
