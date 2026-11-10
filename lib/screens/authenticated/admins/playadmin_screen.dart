import 'package:anpi_report_flutter/entity/topictype.dart';
import 'package:anpi_report_flutter/providers/firestore/profile/profile_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/api/users_api_provider.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../repository/betterauth/session_repository.dart';

@RoutePage()
class PlayAdminScreen extends HookConsumerWidget {
  const PlayAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neonEnabled = SessionRepository.isNeonDataEnabled;
    final asyncProfiles = neonEnabled
        ? ref.watch(neonUsersProvider)
        : ref.watch(streamProfileNotifierProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });
      return () {};
    }, const []);

    List<DataRow> buildRows(List<dynamic> value) {
      return value.map((row) {
        if (neonEnabled) {
          final map = Map<String, dynamic>.from(row as Map);
          final profile = map['profile'] as Map? ?? {};
          final attr = profile['userAttr'] as Map? ?? {};
          final uid = profile['uid']?.toString() ?? '';
          final subscription = attr['subscription'] as int? ?? 0;
          return DataRow(
            cells: [
              DataCell(Text(uid)),
              DataCell(
                Text(
                  getTopicDetailsBySortNumber(subscription)
                      .map((topic) => topic['displayName'])
                      .join(', '),
                ),
              ),
            ],
          );
        }

        final profile = row['profile'];
        return DataRow(
          cells: [
            DataCell(Text(profile?.uid ?? '')),
            DataCell(
              Text(
                getTopicDetailsBySortNumber(
                  profile?.userAttr?['subscription'] ?? 0,
                ).map((topic) => topic['displayName']).join(', '),
              ),
            ),
          ],
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (context.mounted) {
              ref.read(bottomNavNotifierProvider.notifier).show();
              context.router.maybePop();
            }
          },
        ),
        centerTitle: true,
        title: const Text('Profile管理'),
        backgroundColor: Colors.purple[300],
      ),
      body: switch (asyncProfiles) {
        AsyncData(:final value) => SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('uid')),
                  DataColumn(label: Text('subscription')),
                ],
                rows: buildRows(value),
              ),
            ),
          ),
        AsyncError(:final error) =>
          Center(child: Text('エラー: ${error.toString()}')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
