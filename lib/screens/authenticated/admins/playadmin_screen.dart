
import 'package:anpi_report_flutter/entity/topictype.dart';
import 'package:anpi_report_flutter/providers/firestore/profile/profile_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/firestoreuser.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/sqlite/users/unansweredusers_sqlite_provider.dart';

@RoutePage()
class PlayAdminScreen extends HookConsumerWidget {
  const PlayAdminScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(unansweredUsersSQLiteNotifierProvider.notifier);
    final asyncProfiles = ref.watch(streamProfileNotifierProvider);

    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);


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
          title: const Text("Profile管理"),
          backgroundColor: Colors.purple[300],
        ),
        body: switch(asyncProfiles) {
          AsyncData(:final value)
            => SafeArea(
  child: CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              switch(asyncProfiles) {
                AsyncData(:final value) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text("uid")),
                      DataColumn(label: Text("subscription")),
                      // Add more columns as needed for your profile data
                    ],
                    rows: value.map((profile) {
                      return DataRow(
                        cells: [
                          DataCell(Text(profile["profile"]?.uid ?? "")),
                          DataCell(
                            Text
                            (
//                              profile["profile"]?.userAttr?["subscription"].toString() ?? ""
                                        getTopicDetailsBySortNumber(
                                          profile["profile"]?.userAttr?["subscription"] ?? 0
                                        )
                                          .map((topic) => topic['displayName'])
                                          .join(', ')

                            )
                          ),
                          // Add more cells to match your profile data
                        ],
                      );
                    }).toList(),
                  ),
                ),
                AsyncError(:final error) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
                _ => const Center(
                  child: CircularProgressIndicator(),
                ),
              },
            ],
          ),
        ),
      ),
    ],
  ),
),
              AsyncError(:final error) => Center(child: Text('エラー: ${error.toString()}')),
              _ => const Center(child: CircularProgressIndicator()), // Loading state
        }
    );
  }
}
