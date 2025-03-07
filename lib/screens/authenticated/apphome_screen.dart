import 'package:anpi_report_flutter/providers/bottomnav/bottomnav_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/notification/notification.dart';
import '../../models/profile.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/notification/combined_notification_notifier.dart';
import '../../providers/firestore/profile/moiProfile_notifier.dart';
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
    final moiProfile = useState<Profile?>(null);

    final tabController = useTabController(initialLength: 2);
    final authAsyncValue = ref.watch(authStateChangesProvider);
    final unAnsweredNotiBadgeCount = useState<int>(0);
    //final answeredByMeNotificationStream = ref.watch(streamNotificationAnswerByMeNotifierProvider(moiUid.value));
    final profileAsyncValue = ref.watch(streamMoiProfileNotifierProvider(moiUid.value));

    useEffect(() {
      Future.microtask(() {
        ref.read(
          bottomNavNotifierProvider.notifier
        ).show();
        if (moiUid.value.isNotEmpty) {
          ref.invalidate(
            streamNotificationCombinedNotifierProvider(moiUid.value)
          );
        }
      });

      return () {};
    }, const []);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Profile stream
        moiProfile.value = profileAsyncValue.asData?.value;
        debugPrint("moiP : ${moiProfile.value.toString()}");
      }

      return () {};
    }, [authAsyncValue, profileAsyncValue]);

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

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[200],
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
                //notificationStream.asData?.value != null && notificationStream.asData!.value.isNotEmpty
                //?
                TabBarView(
                  controller: tabController,
                  children: [
                    /* Center(child: Text("mikaitou")),
                    Center(child: Text("zumi")), */
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

                                    //
                                    final notiMap = value[index]; 
                                    final noti = notiMap["noti"] as Noti;
                                    final answered = notiMap["answered"] as bool;
                                    // hh:mm
                                  // Check if 'createdAt' exists and is not null
                                    final DateTime? createdAtTimestamp = noti.createdAt;

                                    //debugPrint("**** createdAtTimestamp: ${createdAtTimestamp.toString()} ****");
                                    //debugPrint("**** notiMap **** : ${notiMap.toString()}");

                                    final String formattedTime = createdAtTimestamp != null
                                      ? DateFormat('M/d HH:mm').format(createdAtTimestamp) // Format 'createdAt' if it exists
                                      : "Unknown Time"; // Fallback if 'createdAt' is null

                                    // Filter only answered notifications
                                    if (answered) {
                                      return const SizedBox.shrink(); // Skip un-answered notifications
                                    }
                                    //                                    final docId = notiMap["docId"].toString();
                                    //debugPrint("notiMap: ${notiMap.toString()}");

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
                                        title: Text('[$formattedTime] ${noti.notiTitle}'), 

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

                                    final DateTime? createdAtTimestamp = noti.createdAt;
                                    final String formattedTime = createdAtTimestamp != null
                                      ? DateFormat('M/d HH:mm').format(createdAtTimestamp) // Format 'createdAt' if it exists
                                      : "Unknown Time"; // Fallback if 'createdAt' is null

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
                                        title: Text('[$formattedTime] ${noti.notiTitle}'),
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
              //: const Center(child: CircularProgressIndicator()),
            )
          ],
        )
    );
  }
}
