
import 'package:anpi_report_ios/providers/firestore/notification/notification_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../router/app_router.dart';

@RoutePage()
class NotiAdminRouterScreen extends AutoRouter {
  const NotiAdminRouterScreen({super.key});
}

@RoutePage()
class NotiAdminScreen extends HookConsumerWidget {
  const NotiAdminScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotis = ref.watch(streamNotificationNotifierProvider);

/*    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []); */

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (context.mounted) {
                //
                ref.read(bottomNavNotifierProvider.notifier).show();
                context.router.maybePop();
              }
            },
          ),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.purple[300],
        ),
        body: switch(asyncNotis) {
          AsyncData(:final value) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(
                      label: Text("日時"),
                    ),
                    DataColumn(
                      label: Text("タイトル"),
                    ),
                    DataColumn(
                      label: Text("本文"),
                    ),
                  ],
                  rows: asyncNotis.value.map<DataRow>((data) {
                    final rowRecord = data["noti"];
                    debugPrint("rowRecord: ${rowRecord.toString()}");

                    return DataRow(
                      onSelectChanged: (bool? selected) async {
                        if (selected != null && selected) {
                          // Goto individual noti
                          context.router.push(NotiAdminDetailsRoute(notiId: rowRecord.notificationId));
                        }
                      },
                      cells: [
                      DataCell(Text(DateFormat('[M/d h:mm]').format(rowRecord.createdAt))),
                      DataCell(Text(rowRecord.notiTitle)),
                      DataCell(Text(rowRecord.notiBody)),
                    ]);
                  }).toList(),
                )
              ],
            ),
          ),
          AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
        _ => const Center(child: CircularProgressIndicator()),
      }
    );
  }
}
