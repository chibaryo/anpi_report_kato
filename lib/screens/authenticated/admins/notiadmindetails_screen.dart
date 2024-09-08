
import 'package:anpi_report_ios/entity/userattr/joblevel.dart';
import 'package:anpi_report_ios/providers/firestore/firestoreuser/users_who_did_not_answered_notifier.dart';
import 'package:anpi_report_ios/providers/firestore/notification/notification_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../entity/userattr/department.dart';
import '../../../entity/userattr/office_location.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/notification/notification.dart';
import '../../../models/profile.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';

@RoutePage()
class NotiAdminDetailsScreen extends HookConsumerWidget {
  final String notiId;
  const NotiAdminDetailsScreen({super.key, required this.notiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final authAsyncValue = ref.watch(authStateChangesProvider);
    final notiNotifier = ref.watch(streamNotificationNotifierProvider.notifier);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final currentNoti = useState<Noti?>(null);
    final moiProfile = useState<Profile?>(null);
    final combinedNotiStream = ref.watch(streamAnsOrNotAnsNotificationCombinedNotifierProvider(notiId));

    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;
        });

      }
      // Get noti
      notiNotifier.getNotificationByNotiId(notiId).then((value) {
        currentNoti.value = value;
      });

      return () {};
    }, [authAsyncValue]);

    bool hasBitwiseOverlap(int currentUserDepartments, int userDepartments) {
      return (currentUserDepartments & userDepartments) != 0;
    }
    
    Widget buildDataTable(List<Map<String, dynamic>> notAnsweredUsers) {
      return Text(notAnsweredUsers.toString());
/*      return DataTable(
    columns: const [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Answered')),
    ],
    rows: notAnsweredUsers.map((userMap) {
      final user = userMap['user'] as FirestoreUser;
      final answered = userMap['answered'] as bool;

      return DataRow(cells: [
        DataCell(Text(user.username)), // Assuming FirestoreUser has a name field
        DataCell(Text(user.email)), // Assuming FirestoreUser has an email field
        DataCell(Text(answered ? 'Yes' : 'No')),
      ]);
    }).toList(),
      ); */
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Anpi"),
        backgroundColor: Colors.purple[300],
      ),
      body: Column(
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "回答済みユーザ"),
              Tab(text: "未回答ユーザ"),
            ]
          ),
          // TabBarView
          Expanded(
            child:
              currentNoti.value != null&& combinedNotiStream.asData?.value != null && combinedNotiStream.asData!.value.isNotEmpty
              ? combinedNotiStream.when(
                data: (value) {
                  return TabBarView(
                    controller: tabController,
                    children: [
                      // Answered
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: <Widget>[
                              DataTable(
                                showCheckboxColumn: false,
                                columns: const [
                                  DataColumn(label: Text("名前")),
                                  DataColumn(label: Text("アドレス")),
                                  DataColumn(label: Text("支社")),
                                  DataColumn(label: Text("部署名")),
                                  DataColumn(label: Text("役職")),
                                  DataColumn(label: Text("怪我")),
                                  DataColumn(label: Text("出社")),
                                ],
                                rows: value["answered"]!.where((data) {
                                  final currentUserOfficeLocation = moiProfile.value!.userAttr["officeLocation"];
                                  final currentUserDepartments = moiProfile.value!.userAttr["department"];
                                  debugPrint("### data[profile] : ### : ${data["profile"].userAttr["officeLocation"]}");
                                  final userOfficeLocation = data["profile"].userAttr["officeLocation"];
                                  final userDepartments = data["profile"].userAttr["department"];
                                  debugPrint("### userDepartment ### : $userDepartments");

                                  final isSameOfficeLocation = (currentUserOfficeLocation == userOfficeLocation);
                                  final isDepartmentMatch = hasBitwiseOverlap(currentUserDepartments, userDepartments);

                                  return isSameOfficeLocation && isDepartmentMatch;
                                }).map<DataRow>((data) {
                                  final rowRecordOfUser = data["user"];
                                  final rowRecordOfProfile = data["profile"];
                                  final rowRecordOfReport = data["report"];

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(rowRecordOfUser.username)),
                                      DataCell(Text(rowRecordOfUser.email)),
                                      DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(
                                        rowRecordOfProfile.userAttr["officeLocation"])
                                          ?["displayName"])),
                                      DataCell(Text(getDepartmentTypeDetailsBySortNumber(
                                        rowRecordOfProfile.userAttr["department"])
                                          .map((dept) => dept['displayName'])
                                          .join(', '))),
                                      DataCell(Text(getJobLevelStatusTypeDetailsBySortNumber(
                                        rowRecordOfProfile.userAttr["jobLevel"])
                                        ?["displayName"])),
                                      DataCell(Text(rowRecordOfReport?["injuryStatus"] ?? 'N/A')),
                                      DataCell(Text(rowRecordOfReport?["attendOfficeStatus"] ?? 'N/A')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Not Answered
                      Center(
                        child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: <Widget>[
                  DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text("名前")),
                      DataColumn(label: Text("アドレス")),
                      DataColumn(label: Text("支社")),
                      DataColumn(label: Text("部署名")),
                      DataColumn(label: Text("役職")),
                    ],
                    rows: value["notAnswered"]!.where((data) {
                                  final currentUserOfficeLocation = moiProfile.value!.userAttr["officeLocation"];
                                  final currentUserDepartments = moiProfile.value!.userAttr["department"];
                                  debugPrint("### data[profile] : ### : ${data["profile"].userAttr["officeLocation"]}");
                                  final userOfficeLocation = data["profile"].userAttr["officeLocation"];
                                  final userDepartments = data["profile"].userAttr["department"];
                                  debugPrint("### userDepartment ### : $userDepartments");

                                  final isSameOfficeLocation = (currentUserOfficeLocation == userOfficeLocation);
                                  final isDepartmentMatch = hasBitwiseOverlap(currentUserDepartments, userDepartments);

                                  return isSameOfficeLocation && isDepartmentMatch;
                    }).map<DataRow>((data) {
                      final rowRecordOfUser = data["user"];
                      final rowRecordOfProfile = data["profile"];

                      return DataRow(
                        cells: [
                          DataCell(Text(rowRecordOfUser.username)),
                          DataCell(Text(rowRecordOfUser.email)),
                          DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(
                                  rowRecordOfProfile.userAttr["officeLocation"])
                              ?["displayName"])),
                          DataCell(Text(getDepartmentTypeDetailsBySortNumber(
                                  rowRecordOfProfile.userAttr["department"])
                              .map((dept) => dept['displayName'])
                              .join(', '))),
                          DataCell(Text(getJobLevelStatusTypeDetailsBySortNumber(
                                  rowRecordOfProfile.userAttr["jobLevel"])
                              ?["displayName"])),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
                      ),
                    ],
                  );
                                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              )
/*              TabBarView(
                controller: tabController,
                children: [
                  // Answered
                  Center(
                      child: switch(combinedNotiStream) {
                        AsyncData(:final value) =>
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: <Widget>[
                                DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text("名前"),
                                    ),
                                    DataColumn(
                                      label: Text("アドレス"),
                                    ),
                                    DataColumn(
                                      label: Text("支社"),
                                    ),
                                    DataColumn(
                                      label: Text("部署名"),
                                    ),
                                    DataColumn(
                                      label: Text("役職"),
                                    ),
                                    DataColumn(
                                      label: Text("怪我"),
                                    ),
                                    DataColumn(
                                      label: Text("出社"),
                                    ), /*
                                    DataColumn(
                                      label: Text("msg"),
                                    ),
                                    DataColumn(
                                      label: Text("位置情報"),
                                    ), */
                                  ],
                                  rows: value["answered"]!.map<DataRow>((data) {
                                    final rowRecordOfUser = data["user"];
                                    final rowRecordOfProfile = data["profile"];
                                    final rowRecordOfReport = data["report"];

                                    debugPrint("answered: ${rowRecordOfReport.toString()}");

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(rowRecordOfUser.username)),
                                        DataCell(Text(rowRecordOfUser.email)),
                                        DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["officeLocation"])?["displayName"])),
                                        DataCell(
                                          Text(
                                            getDepartmentTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["department"])
                                            .map((dept) => dept['displayName']) // Extract 'displayName' from each map
                                            .join(', ') // Join them into a comma-separated string
                                          )
                                        ),
                                        DataCell(
                                          Text(
                                            getJobLevelStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["jobLevel"])?["displayName"]
                                          )
                                        ),
                                        DataCell(Text(rowRecordOfReport?["injuryStatus"] ?? 'N/A')), // Default to 'N/A' if null
                                        DataCell(Text(rowRecordOfReport?["attendOfficeStatus"] ?? 'N/A')),
                                        /* DataCell(Text(rowRecord.attendOfficeStatus)),
                                        DataCell(Text(rowRecord.message)),
                                        DataCell(Text(rowRecord.locationAddr)), */
                                      ]
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
                          _ => const Center(child: CircularProgressIndicator()),
                      },
                  ),
                  // Not answered
                  combinedNotiStream.when(
                    data: (value) {
                      final currentUserOfficeLocation = moiProfile.value!.userAttr["officeLocation"];
                      final currentUserDepartment = moiProfile.value!.userAttr["department"];

                      // Filter not answered users
                      final filteredNotAnswered = value["notAnswered"]!.where((data) {
                      final userOfficeLocation = data["profile"]["userAttr"]["officeLocation"];
                      final userDepartment = data["profile"]["userAttr"]["department"];
                        return (currentUserOfficeLocation == userOfficeLocation) &&
                               (currentUserDepartment.contains(userDepartment));
                      }).toList();

                      return const Text("foo");
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                      Center(child: Text('Error: $error')),                  
                  ),
                  Center(
                      child: combinedNotiStream.when(
                        data: (value) {
                          final currentUserOfficeLocation = moiProfile.value!.userAttr["officeLocation"];
                          final currentUserDepartment = moiProfile.value!.userAttr["department"];

                          // Filter not answered users
                          final filteredNotAnswered = value["notAnswered"]!.where((data) {
                            final userOfficeLocation = data["profile"]["userAttr"]["officeLocation"];
                            final userDepartment = data["profile"]["userAttr"]["department"];
                            return (currentUserOfficeLocation == userOfficeLocation) &&
                                   (currentUserDepartment.contains(userDepartment));
                          }).toList();

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: <Widget>[
                                DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text("名前"),
                                    ),
                                    DataColumn(
                                      label: Text("アドレス"),
                                    ),
                                    DataColumn(
                                      label: Text("支社"),
                                    ),
                                    DataColumn(
                                      label: Text("部署名"),
                                    ),
                                    DataColumn(
                                      label: Text("役職"),
                                    ),
                                  ],
                                  rows: value["notAnswered"]!.map<DataRow>((data) {
                                    final rowRecordOfUser = data["user"];
                                    final rowRecordOfProfile = data["profile"];

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(rowRecordOfUser.username)),
                                        DataCell(Text(rowRecordOfUser.email)),
                                        DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["officeLocation"])?["displayName"])),
                                        DataCell(
                                          Text(
                                            getDepartmentTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["department"])
                                            .map((dept) => dept['displayName']) // Extract 'displayName' from each map
                                            .join(', ') // Join them into a comma-separated string
                                          )
                                        ),
                                        DataCell(
                                          Text(
                                            getJobLevelStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["jobLevel"])?["displayName"]
                                          )
                                        ),
                                      ]
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          );
                        },
                        error:
                        
                      )

                       {
                        AsyncData(:final value) {
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: <Widget>[
                                DataTable(
                                  showCheckboxColumn: false,
                                  columns: const [
                                    DataColumn(
                                      label: Text("名前"),
                                    ),
                                    DataColumn(
                                      label: Text("アドレス"),
                                    ),
                                    DataColumn(
                                      label: Text("支社"),
                                    ),
                                    DataColumn(
                                      label: Text("部署名"),
                                    ),
                                    DataColumn(
                                      label: Text("役職"),
                                    ),
/*                                    DataColumn(
                                      label: Text("怪我"),
                                    ),
                                    DataColumn(
                                      label: Text("出社"),
                                    ),
                                    DataColumn(
                                      label: Text("msg"),
                                    ),
                                    DataColumn(
                                      label: Text("位置情報"),
                                    ), */
                                  ],
                                  rows: value["notAnswered"]!.map<DataRow>((data) {
                                    final rowRecordOfUser = data["user"];
                                    final rowRecordOfProfile = data["profile"];

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(rowRecordOfUser.username)),
                                        DataCell(Text(rowRecordOfUser.email)),
                                        DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["officeLocation"])?["displayName"])),
                                        DataCell(
                                          Text(
                                            getDepartmentTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["department"])
                                            .map((dept) => dept['displayName']) // Extract 'displayName' from each map
                                            .join(', ') // Join them into a comma-separated string
                                          )
                                        ),
                                        DataCell(
                                          Text(
                                            getJobLevelStatusTypeDetailsBySortNumber(rowRecordOfProfile.userAttr["jobLevel"])?["displayName"]
                                          )
                                        ),
                                      ]
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          );},
                        AsyncError(:final error) =>
                          Text("error: $error")
                          /*CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: value.length,
                                    (BuildContext context, int index) {
                                      final userMap = value[index];
                                      final user = userMap["user"];
                                      final answered = userMap["answered"] as bool;
                                      final notAnsweredUsers = value.where((userMap) => userMap['answered'] == false).toList();

                                      if (answered) {
                                        return const SizedBox.shrink(); // Skip
                                      }

                                      //return Text("${user.toString()}");
                                      return buildDataTable(notAnsweredUsers); //
                                    }
                                  ),
                                ),
                              )
                            ],
                          ),*/
                        },
                  ),
                ],
              ) */
              : const Text("is Loading..."),
          ),
        ],
      )
/*
      currentNoti.value != null&& combinedNotiStream.asData?.value != null && combinedNotiStream.asData!.value.isNotEmpty
      ? switch(combinedNotiStream) {
        AsyncData(:final value) =>
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: value.length,
                    (BuildContext context, int index) {
                      final userMap = value[index];
                      final user = userMap["user"];
                      return Text("${user.toString()}");
                    }
                  ),
                ),
              )
            ],
          ),
          AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
            _ => const Center(child: CircularProgressIndicator()),                      
      }
      : const Text("is Loading...") */
      //,
    );
  }
}
