
import 'package:anpi_report_flutter/entity/userattr/joblevel.dart';
import 'package:anpi_report_flutter/providers/firestore/firestoreuser/users_who_did_not_answered_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/notification/notification_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/userreport/answereduserreport_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/userreport/unanswereduserlist_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../entity/userattr/department.dart';
import '../../../entity/userattr/office_location.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/notification/notification.dart';
import '../../../models/profile.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../providers/progress/progress_notifier.dart';

@RoutePage()
class NotiAdminDetailsScreen extends HookConsumerWidget {
  final String notiId;
  const NotiAdminDetailsScreen({super.key, required this.notiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final unAnsweredUsersUids = useState<List<String>>([]);
    final authAsyncValue = ref.watch(authStateChangesProvider);
    final notiNotifier = ref.watch(streamNotificationNotifierProvider.notifier);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final currentNoti = useState<Noti?>(null);
    final moiProfile = useState<Profile?>(null);
    /** new ***/
    final answeredUsersReportStream = ref.watch(streamAnsweredUserReportNotifierProvider(notiId));
    final unansweredUsers = ref.watch(fetchUnansweredUsersProvider(notiId));
    //final unansweredUsersStream = ref.watch(streamUnansweredUserNotifierProvider(notiId));
    final progress = ref.watch(progressNotifierProvider);

    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      final user = authAsyncValue.asData?.value;

      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid (notiAdminDetail): ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;
          debugPrint("officeLocation: ${profile?.userAttr["officeLocation"].toString()}");
        });

      }
      // Get noti
      notiNotifier.getNotificationByNotiId(notiId).then((value) {
        currentNoti.value = value;
        if (currentNoti.value != null) {
          debugPrint("currentNoti.value: ${currentNoti.value.toString()}");
        }
      });

      return () {};
    }, [authAsyncValue]);

    bool hasBitwiseOverlap(int currentUserDepartments, int userDepartments) {
      return (currentUserDepartments & userDepartments) != 0;
    }

// Filter unanswered users based on officeLocation and jobLevel
/*final filteredUnansweredUsers = unansweredUsersStream.when(
  data: (unansweredData) {
    if (moiProfile.value?.userAttr["jobLevel"] == 2) {
      final myOfficeLocation = moiProfile.value?.userAttr["officeLocation"];
      final myDepartments = moiProfile.value?.userAttr["department"];

      return unansweredData.where((userData) {
        final userOfficeLocation = userData["profile"]["userAttr"]["officeLocation"];
        final userDepartments = userData["profile"]["userAttr"]["department"];
        return userOfficeLocation == myOfficeLocation && hasBitwiseOverlap(userDepartments, myDepartments);
      }).toList();
    }
    return unansweredData; // No filtering if jobLevel is not 2
  },
  loading: () => <Map<String, dynamic>>[],
  error: (error, stack) => <Map<String, dynamic>>[],
); */

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (context.mounted) {
                  //
                  ref.read(bottomNavNotifierProvider.notifier).show();
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
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "回答済みユーザ"),
              Tab(text: "未回答ユーザ"),
            ]
          ),
/*          if (unansweredUsersStream.isLoading)
            Center(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              ),
            ), */
          // TabBarView
          Expanded(
            child:
              switch((answeredUsersReportStream, unansweredUsers)) {
                (AsyncData(value: final answeredData), AsyncData(value: final unansweredData)) =>
                  TabBarView(
                    controller: tabController,
                    children: [
                      // Answered
CustomScrollView(
  slivers: [
    SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text("名前")),
                  DataColumn(label: Text("アドレス")),
                  DataColumn(label: Text("支社")),
                  DataColumn(label: Text("部署名")),
                  DataColumn(label: Text("役職")),
                  DataColumn(label: Text("怪我")),
                  DataColumn(label: Text("出社")),
                  DataColumn(label: Text("位置情報")),
                  DataColumn(label: Text("伝言")),
                  DataColumn(label: Text("確認したか")),
                ],
                rows: answeredData.map((data) {
                  final reportObject = data["report"];
                  final user = data["user"] as Map<String, dynamic>?;
                  final profile = data["profile"] as Map<String, dynamic>?;

                  return DataRow(
                    cells: [
                      DataCell(Text(user?['username'] ?? 'Unknown User')),
                      DataCell(Text(user?['email'] ?? 'N/A')),
                      DataCell(Text(getOfficeLocationStatusTypeDetailsBySortNumber(profile?["userAttr"]["officeLocation"])?["displayName"])),
                      DataCell(Text(getDepartmentTypeDetailsBySortNumber(
                        profile?["userAttr"]["department"])
                        .map((dept) => dept['displayName'])
                        .join(', '))),
                      DataCell(Text(getJobLevelStatusTypeDetailsBySortNumber(profile?["userAttr"]["jobLevel"])?["displayName"])),
                      DataCell(Text(reportObject.reportContents["injuryStatus"] ?? "-")),
                      DataCell(Text(reportObject.reportContents["attendOfficeStatus"] ?? "-")),
                      DataCell(Text(reportObject.reportContents["location"] ?? "-")),
                      DataCell(Text(reportObject.reportContents["message"] ?? "-")),
                      DataCell(reportObject.reportContents["isConfirmed"] ? const Text("はい") : const Text("いいえ")),
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
                      CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: unansweredData.length,
                                (BuildContext context, int index) {
                                  final user = unansweredData[index]["user"]; 
                                  final profile = unansweredData[index]["profile"];

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(user["username"]),
                                        Text(user["email"]),
                                        Text(getOfficeLocationStatusTypeDetailsBySortNumber(profile["userAttr"]["officeLocation"])?["displayName"]),
                                        Text(getDepartmentTypeDetailsBySortNumber(
                                          profile["userAttr"]["department"])
                                          .map((dept) => dept['displayName'])
                                          .join(', ')),
                                      ],
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                        ] 
                      ),
                    ],
                  ),
/*
                  CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: value.length,
                            (BuildContext context, int index) {
                              final reportObject = value[index]["report"]; 
                              final profileRef = reportObject.profileRef as DocumentReference<Map<String, dynamic>>;
                              final userRef = reportObject.userRef as DocumentReference<Map<String, dynamic>>;

                              return FutureBuilder(
                                future: Future.wait([
                                  profileRef.get(),
                                  userRef.get(),
                                ]),
                                builder: (context, AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Show a loader while fetching
                                  }

                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }

                                  if (!snapshot.hasData || snapshot.data!.any((doc) => !doc.exists)) {
                                    return const Text("Profile or User not found.");
                                  }

                                  // Extract profile and user data
                                  final profileDoc = snapshot.data![0];
                                  final userDoc = snapshot.data![1];

                                  // Convert to Profile and User objects
                                  final profile = Profile.fromJson(profileDoc.data()!);
                                  final user = FirestoreUser.fromJson(userDoc.data()!);

                                  // Print the data
                                  debugPrint("Profile Data: ${profile.toString()}");
                                  debugPrint("User Data: ${user.toString()}");

                                  // Display the profile and user data in the UI
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("氏名: ${user.username}"),
                                      Text("Email: ${user.email}"),
                                      Text(getDepartmentTypeDetailsBySortNumber(
                                        profile.userAttr["department"])
                                        .map((dept) => dept['displayName'])
                                        .join(', ')),
                                      Text('支社: ${getOfficeLocationStatusTypeDetailsBySortNumber(profile.userAttr["officeLocation"])?["displayName"]}'),
                                      Text('職位: ${getJobLevelStatusTypeDetailsBySortNumber(profile.userAttr["jobLevel"])?["displayName"]}'),
                                      currentNoti.value?.notiType == 2
                                      ?
                                      // Confirmation only
                                      Text('確認したか？: ${reportObject.reportContents["isConfirmed"] ? "はい" : "いいえ"}')
                                      :
                                      // Enquete
                                      const Text("アンケート項目への回答")
                                    ],
                                  );
                                },
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  ),
*/
                (AsyncError _, AsyncError _) => const Text('Error'),
                  (_, _) => Expanded(
                    child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                                    ),
                                    Text("${(progress * 100).toStringAsFixed(0)} パーセント ロード中...")
                                  ],
                                ),
                              ),
                  ),
                },
/*              currentNoti.value != null && combinedNotiStream.asData?.value != null && combinedNotiStream.asData!.value.isNotEmpty
              ? combinedNotiStream.when(
                data: (value) {
                  return TabBarView(
                    controller: tabController,
                    children: [
                      // Answered
                      Center(
                        child: ListView(
                          children: [
                            SingleChildScrollView(
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
                          ],
                        ),
                      ),
                      // Not Answered
                      Center(
                        child: ListView(
                          children: [
                            SingleChildScrollView(
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
                                      final currentUserJobLevel = moiProfile.value!.userAttr["jobLevel"];
                            
                                      debugPrint("### data[profile] : ### : ${data["profile"].userAttr["officeLocation"]}");
                                      final userOfficeLocation = data["profile"].userAttr["officeLocation"];
                                      final userDepartments = data["profile"].userAttr["department"];
                                      debugPrint("### userDepartment ### : $userDepartments");
                            
                                      final isSameOfficeLocation = (currentUserOfficeLocation == userOfficeLocation);
                                      final isDepartmentMatch = hasBitwiseOverlap(currentUserDepartments, userDepartments);
                            
                                      // Determine the filtering logic based on currentUserJobLevel
                                      if (currentUserJobLevel == 4) {
                                        // Show all unanswered users
                                        return true;
                                      } else if (currentUserJobLevel == 2) {
                                        // Show unanswered users with matching officeLocation and department
                                        return isSameOfficeLocation && isDepartmentMatch;
                                      }
                            
                                      // Default case if job level is not 2 or 4, return false
                                      return false;
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
                          ],
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
              : const Text("is Loading..."), */
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
