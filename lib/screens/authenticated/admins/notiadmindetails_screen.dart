import 'package:anpi_report_flutter/entity/userattr/joblevel.dart';
import 'package:anpi_report_flutter/providers/firestore/notification/notification_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/userreport/answereduserreport_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/userreport/unanswereduserlist_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../entity/report/attendoffice_status.dart';
import '../../../entity/report/injury_status.dart';
import '../../../entity/topictype.dart';
import '../../../entity/userattr/department.dart';
import '../../../entity/userattr/office_location.dart';
import '../../../models/notification/notification.dart';
import '../../../models/profile.dart';
import '../../../providers/api/me_api_provider.dart';
import '../../../providers/api/notifications_api_provider.dart';
import '../../../repository/api/notifications_api_repository.dart';
import '../../../repository/betterauth/session_repository.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../providers/progress/progress_notifier.dart';

@RoutePage()
class NotiAdminDetailsScreen extends HookConsumerWidget {
  final String notiId;
  const NotiAdminDetailsScreen({super.key, required this.notiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neonEnabled = SessionRepository.isNeonDataEnabled;
    final moiUid = useState<String>("");
    final authAsyncValue = neonEnabled
        ? const AsyncValue.data(null)
        : ref.watch(authStateChangesProvider);
    final notiNotifier = neonEnabled
        ? null
        : ref.watch(streamNotificationNotifierProvider.notifier);
    final profileNotifier = neonEnabled
        ? null
        : ref.watch(streamProfileNotifierProvider.notifier);
    final currentNoti = useState<Noti?>(null);
    final moiProfile = useState<Profile?>(null);
    final neonProfileAsync =
        neonEnabled ? ref.watch(neonMoiProfileProvider) : null;
  /** new ***/
    final answeredUsersReportStream = neonEnabled
        ? ref.watch(neonNotificationReportsProvider(notiId))
        : ref.watch(streamAnsweredUserReportNotifierProvider(notiId));
    final unansweredUsers = neonEnabled
        ? ref.watch(neonNotificationUnansweredProvider(notiId))
        : ref.watch(fetchUnansweredUsersProvider(notiId));
    final filteredUnansweredUsers = useState<List<Map<String, dynamic>>>([]);
    //final unansweredUsersStream = ref.watch(streamUnansweredUserNotifierProvider(notiId));
    final progress = ref.watch(progressNotifierProvider);

    final tabController = useTabController(initialLength: 2);

    DateTime? parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

  Noti notiFromNeonRow(Map<String, dynamic> row) {
    final payload = row['payload'];
    final payloadMap =
        payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
    final typeRaw = payloadMap['notiType'] ?? payloadMap['type'] ?? 0;
    return Noti(
      notificationId: row['id']?.toString() ?? '',
      notiTitle: row['title']?.toString() ??
          payloadMap['notiTitle']?.toString() ??
          '',
      notiBody:
          row['body']?.toString() ?? payloadMap['notiBody']?.toString() ?? '',
      notiType: typeRaw is int ? typeRaw : int.tryParse(typeRaw.toString()) ?? 0,
      notiTopic: row['noti_topic']?.toString() ??
          payloadMap['notiTopic']?.toString() ??
          '',
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }

    useEffect(() {
      if (neonEnabled) {
        moiProfile.value = neonProfileAsync?.asData?.value;
        NotificationsApiRepository()
            .getNotification(notiId)
            .then((row) {
          if (row != null) {
            currentNoti.value = notiFromNeonRow(row);
          }
        });
        return () {};
      }

      final user = authAsyncValue.asData?.value;

      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid (notiAdminDetail): ${moiUid.value}");

        profileNotifier?.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;
          debugPrint(
              "officeLocation: ${profile?.userAttr["officeLocation"].toString()}");
        });
      }
      notiNotifier?.getNotificationByNotiId(notiId).then((value) {
        currentNoti.value = value;
        if (currentNoti.value != null) {
          debugPrint("currentNoti.value: ${currentNoti.value.toString()}");
        }
      });

      return () {};
    }, [authAsyncValue, neonEnabled, neonProfileAsync, notiId]);

    bool hasBitwiseOverlap(int currentUserDepartments, int userDepartments) {
      return (currentUserDepartments & userDepartments) != 0;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (context.mounted) {
              //ref.read(bottomNavNotifierProvider.notifier).show();
              context.router.back();
            }
          },
        ),
        centerTitle: true,
        title: const Text("Anpi"),
        backgroundColor: Colors.purple[300],
      ),
      body: Column(
        children: <Widget>[
          // TabBar
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "回答済みユーザ"),
              Tab(text: "未回答ユーザ"),
            ],
          ),
          // TabBarView wrapped in Expanded
          Expanded(
            child: switch ((answeredUsersReportStream, unansweredUsers)) {
              (
                AsyncData(value: final answeredData),
                AsyncData(value: final unansweredData)
              ) =>
                TabBarView(
                  controller: tabController,
                  children: [
                    // Answered Users Tab
                    CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    showCheckboxColumn: false,
                                    columns: const [
                                      DataColumn(label: Text("名前")),
                                      //DataColumn(label: Text("アドレス")),
                                      DataColumn(label: Text("支社")),
                                      DataColumn(label: Text("部署名")),
                                      DataColumn(label: Text("役職")),
//                                      DataColumn(label: Text("購読トピック")),
                                      DataColumn(label: Text("怪我")),
                                      DataColumn(label: Text("出社")),
                                      DataColumn(label: Text("位置情報")),
                                      DataColumn(label: Text("伝言")),
                                      DataColumn(label: Text("確認したか")),
                                    ],
                                    rows: answeredData.where((data) {
                                      // Filtering logic
                                      final moiOfficeLocation = moiProfile
                                          .value?.userAttr["officeLocation"];
                                      final moiDepartment = moiProfile
                                          .value?.userAttr["department"];
                                      final moiJobLevel = moiProfile
                                          .value?.userAttr["jobLevel"];
                                      final moiSubscription = moiProfile
                                          .value?.userAttr["subscription"];

                                      final profile = data["profile"]
                                          as Map<String, dynamic>?;
                                      final targetOfficeLocation =
                                          profile?['userAttr']
                                              ["officeLocation"];
                                      final targetDepartment =
                                          profile?['userAttr']["department"];
                                      final targetSubscription =
                                          profile?['userAttr']['subscription'];

                                      // Apply filtering based on job level, office location, and department
                                      if (moiJobLevel == 2) {
                                        final isSameOfficeLocation =
                                            (moiOfficeLocation ==
                                                targetOfficeLocation);
                                        final isDepartmentMatch =
                                            hasBitwiseOverlap(moiDepartment,
                                                targetDepartment);
                                        final isSubscriptionMatch =
                                            hasBitwiseOverlap(moiSubscription,
                                                targetSubscription ?? 0);
                                        // Combine all required conditions
                                        return isSameOfficeLocation &&
                                            isDepartmentMatch &&
                                            isSubscriptionMatch;
                                      } else if (moiJobLevel == 4) {
                                        final isSubscriptionMatch =
                                            hasBitwiseOverlap(moiSubscription,
                                                targetSubscription ?? 0);
                                        return isSubscriptionMatch;
                                        //return true;
                                      } else if (moiJobLevel == 8) {
                                        return true;
                                      } else {
                                        return true;
                                      }
                                    }).map((data) {
                                      final reportObject = data["report"];
                                      final user =
                                          data["user"] as Map<String, dynamic>?;
                                      final profile = data["profile"]
                                          as Map<String, dynamic>?;

                                      return DataRow(
                                        cells: [
                                          DataCell(Text(user?['username'] ??
                                              'Unknown User')),
                                          /* DataCell(
                                              Text(user?['email'] ?? 'N/A')), */
                                          DataCell(Text(
                                              getOfficeLocationStatusTypeDetailsBySortNumber(
                                                      profile?["userAttr"]
                                                          ["officeLocation"])?[
                                                  "displayName"])),
                                          DataCell(Text(
                                              getDepartmentTypeDetailsBySortNumber(
                                                      profile?["userAttr"]
                                                          ["department"])
                                                  .map((dept) =>
                                                      dept['displayName'])
                                                  .join(', '))),
                                          DataCell(Text(
                                              getJobLevelStatusTypeDetailsBySortNumber(
                                                      profile?["userAttr"]
                                                          ["jobLevel"])?[
                                                  "displayName"])),
                                          DataCell(Text(
                                              getInjuryStatusTypeDetailsBySortNumber(
                                                          reportObject
                                                                  .reportContents[
                                                              "injuryStatus"])?[
                                                      "displayName"] ??
                                                  "-")),
                                          DataCell(Text(
                                              getAttendOfficeStatusTypeDetailsBySortNumber(
                                                          reportObject
                                                                  .reportContents[
                                                              "attendOfficeStatus"])?[
                                                      "displayName"] ??
                                                  "-")),
                                          DataCell(Text(reportObject
                                                  .reportContents["location"] ??
                                              "-")),
                                          DataCell(Text(reportObject
                                                  .reportContents["message"] ??
                                              "-")),
                                          DataCell(reportObject
                                                  .reportContents["isConfirmed"]
                                              ? const Text("はい")
                                              : const Text("いいえ")),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Unanswered Users Tab
                    CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    showCheckboxColumn: false,
                                    columns: const [
                                      DataColumn(label: Text("名前")),
                                      // DataColumn(label: Text("アドレス")),
                                      DataColumn(label: Text("支社")),
                                      DataColumn(label: Text("部署名")),
                                      DataColumn(label: Text("役職")),
                                      DataColumn(label: Text("購読トピック")),
                                    ],
                                    rows: unansweredData.where((data) {
                                      // Filtering logic
                                      final moiOfficeLocation = moiProfile
                                          .value?.userAttr["officeLocation"];
                                      final moiDepartment = moiProfile
                                          .value?.userAttr["department"];
                                      final moiJobLevel = moiProfile
                                          .value?.userAttr["jobLevel"];
                                      final moiSubscription = moiProfile
                                          .value?.userAttr["subscription"];

                                      final profile = data["profile"]
                                          as Map<String, dynamic>?;
                                      final targetOfficeLocation =
                                          profile?['userAttr']
                                              ["officeLocation"];
                                      final targetDepartment =
                                          profile?['userAttr']["department"];
                                      final targetSubscription =
                                          profile?['userAttr']['subscription'];

                                      // Apply filtering based on job level, office location, and department
                                      if (moiJobLevel == 2) {
                                        final isOfficeLocationMatch =
                                            hasBitwiseOverlap(moiOfficeLocation,
                                                targetOfficeLocation);
                                        if (isOfficeLocationMatch) {
                                          debugPrint("im included");
                                        } else {
                                          debugPrint("im without");
                                        }
                                        final isSameOfficeLocation =
                                            (moiOfficeLocation ==
                                                targetOfficeLocation);
                                        final isDepartmentMatch =
                                            hasBitwiseOverlap(moiDepartment,
                                                targetDepartment);
                                        final isSubscriptionMatch =
                                            hasBitwiseOverlap(moiSubscription,
                                                targetSubscription ?? 0);
                                        return isOfficeLocationMatch &&
                                            isDepartmentMatch &&
                                            isSubscriptionMatch;
                                      } else if (moiJobLevel == 4) {
                                        final isSubscriptionMatch =
                                            hasBitwiseOverlap(moiSubscription,
                                                targetSubscription ?? 0);
                                        return isSubscriptionMatch; 
                                        //return true;
                                      } else if (moiJobLevel == 8) {
                                        return true;
                                      } else {
                                        return true;
                                      }
                                    }).map<DataRow>((data) {
                                      final user =
                                          data["user"] as Map<String, dynamic>?;
                                      final profile = data["profile"]
                                          as Map<String, dynamic>?;

                                      return DataRow(
                                        cells: [
                                          DataCell(Text(user?['username'] ??
                                              'Unknown User')),
                                          /* DataCell(Text(user?['email'] ??
                                              'Unknown address')), */
                                          DataCell(Text(
                                              getOfficeLocationStatusTypeDetailsBySortNumber(
                                                          profile?["userAttr"][
                                                              "officeLocation"])?[
                                                      "displayName"] ??
                                                  'Unknown OfficeLocation')),
                                          DataCell(Text(
                                              getDepartmentTypeDetailsBySortNumber(
                                                      profile?['userAttr']
                                                          ["department"])
                                                  .map((dept) =>
                                                      dept['displayName'])
                                                  .join(', '))),
                                          DataCell(Text(
                                              getJobLevelStatusTypeDetailsBySortNumber(
                                                          profile?['userAttr']
                                                              ["jobLevel"])?[
                                                      "displayName"] ??
                                                  'Unknown jobLevel')),
                                          DataCell(Text(
                                              getTopicDetailsBySortNumber(
                                                      profile?['userAttr']
                                                          ["subscription"] ?? 0)
                                                  .map((dept) =>
                                                      dept['displayName'])
                                                  .join(', '))),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              (AsyncError _, AsyncError _) => const Text('Error'),
              (_, _) => neonEnabled
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.deepPurpleAccent),
                          ),
                          Text(
                              "${(progress * 100).toStringAsFixed(0)} パーセント ロード中...")
                        ],
                      ),
                    ),
            },
          ),
        ],
      ),
    );
  }
}
