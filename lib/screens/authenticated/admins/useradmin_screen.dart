import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../entity/userattr/department.dart';
import '../../../entity/userattr/joblevel.dart';
import '../../../entity/userattr/office_location.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/profile.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';

@RoutePage()
class UserAdminScreen extends HookConsumerWidget {
  const UserAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final moiUser = useState<FirestoreUser?>(null);
    final moiProfile = useState<Profile?>(null);
    final filteredUsers = useState<List<Map<String, dynamic>>>([]);
    final isLoading = useState<bool>(true); // Track loading status
    final hasFilteredData = useState<bool>(false); // Track if data has been filtered

    final authAsyncValue = ref.watch(authStateChangesProvider);
    final asyncUsers = ref.watch(streamUserNotifierProvider);
    final userNotifier = ref.watch(streamUserNotifierProvider.notifier);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;

          // Get user by uid
          userNotifier.getUserByUid(moiUid.value).then((firestoreUser) {
            moiUser.value = firestoreUser;
          });
        });
      }

      return () {};
    }, [authAsyncValue]);

    useEffect(() {
      asyncUsers.whenData((value) {
        final currentUserProfile = moiProfile.value;
        final currentUserJobLevel = currentUserProfile?.userAttr["jobLevel"];

        int? departmentFilter;
        String? officeLocationFilter;

        if (currentUserJobLevel == 2) {
          // Example filters, replace with your actual filter values
          officeLocationFilter = 'desiredOfficeLocation'; // Replace with your actual filter
          departmentFilter = DepartmentType.candidate_05.sortNumber | DepartmentType.candidate_06.sortNumber; // Example filter: departments 5 and 6
        }

        // Filter the users
        final usersList = value.where((data) {
          final rowRecordOfProfile = data["profile"];
          final userJobLevel = rowRecordOfProfile["userAttr"]["jobLevel"];

          if (userJobLevel == 2) {
            final userOfficeLocation = rowRecordOfProfile["userAttr"]["officeLocation"];
            final userDepartments = rowRecordOfProfile["userAttr"]["department"];

            final officeLocationMatch = officeLocationFilter == null || userOfficeLocation == officeLocationFilter;
            final departmentsMatch = departmentFilter == null || (userDepartments & departmentFilter) != 0;

            return officeLocationMatch && departmentsMatch;
          }

          return true;
        }).toList();

        // Update state with filtered users and mark data as ready
        filteredUsers.value = usersList;
        isLoading.value = false; // Set loading to false after filtering
        hasFilteredData.value = true; // Mark filtered data as available
      });

      return () {};
    }, [asyncUsers, moiProfile.value]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Anpi"),
        backgroundColor: Colors.purple[300],
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : hasFilteredData.value
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: filteredUsers.value.isEmpty
                      ? const Center(child: Text('No data available.'))
                      : DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text("名前")),
                            DataColumn(label: Text("アドレス")),
                            DataColumn(label: Text("支社")),
                            DataColumn(label: Text("部署名")),
                            DataColumn(label: Text("役職")),
                          ],
                          rows: filteredUsers.value.map<DataRow>((data) {
                            final rowRecordOfUser = data["user"];
                            final rowRecordOfProfile = data["profile"];
                            debugPrint("###??? rowRecordOfProfile: $rowRecordOfProfile");

                            return DataRow(
                              cells: [
                                DataCell(Text(rowRecordOfUser.username)),
                                DataCell(Text(rowRecordOfUser.email)),
                                DataCell(
                                  Text(
                                    getOfficeLocationStatusTypeDetailsBySortNumber(
                                      rowRecordOfProfile["userAttr"]["officeLocation"]
                                    )?["displayName"] ?? 'Unknown'
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    getDepartmentTypeDetailsBySortNumber(
                                      rowRecordOfProfile["userAttr"]["department"]
                                    )
                                      .map((dept) => dept['displayName'])
                                      .join(', ')
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    getJobLevelStatusTypeDetailsBySortNumber(
                                      rowRecordOfProfile["userAttr"]["jobLevel"]
                                    )?["displayName"] ?? 'Unknown'
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                )
              : const Center(child: Text('No data available.')),
    );
  }
}
