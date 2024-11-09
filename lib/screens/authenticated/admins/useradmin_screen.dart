import 'package:auto_route/auto_route.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../entity/userattr/department.dart';
import '../../../entity/userattr/joblevel.dart';
import '../../../entity/userattr/office_location.dart';
import '../../../models/deviceinfo.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/profile.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/deviceinfo/deviceinfo_notifier.dart';
import '../../../providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../repository/firebase/authrepo.dart';

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
    final deviceInfoNotifier = ref.watch(streamDeviceInfoNotifierProvider.notifier);

    final AuthService authService = AuthService();

    // fields
    final tFieldUserNameController = useTextEditingController();
    final tFieldEmailController = useTextEditingController();
    final tFieldPasswordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    const storage = FlutterSecureStorage();

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      return () {};
    }, const []);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;
          debugPrint("moiProfile.value: ${moiProfile.value}");

          // Get user by uid
          userNotifier.getUserByUid(moiUid.value).then((firestoreUser) {
            moiUser.value = firestoreUser;
          });
        });
      }

      return () {};
    }, [authAsyncValue]);

    bool hasBitwiseOverlap(int currentUserDepartments, int userDepartments) {
      return (currentUserDepartments & userDepartments) != 0;
    }

    useEffect(() {
      asyncUsers.whenData((value) {
        final currentUserProfile = moiProfile.value;
        final currentUserJobLevel = currentUserProfile?.userAttr["jobLevel"];
        final currentUserOfficeLocation = currentUserProfile?.userAttr["officeLocation"];
        final currentUserDepartments = currentUserProfile?.userAttr["department"];
        debugPrint("currentUserJobLevel: $currentUserJobLevel");

//        int? departmentFilter;
//        String? officeLocationFilter;

/*        if (currentUserJobLevel == 2) {
          // Example filters, replace with your actual filter values
          officeLocationFilter = 'desiredOfficeLocation'; // Replace with your actual filter
          departmentFilter = DepartmentType.candidate_05.sortNumber | DepartmentType.candidate_06.sortNumber; // Example filter: departments 5 and 6
        } */

        // Filter the users
        final usersList = value.where((data) {
          final rowRecordOfProfile = data["profile"];
          final userJobLevel = rowRecordOfProfile["userAttr"]["jobLevel"];
          debugPrint("userJobLevel: $userJobLevel");

          if (currentUserJobLevel == 2) {
            final userOfficeLocation = rowRecordOfProfile["userAttr"]["officeLocation"];
            final userDepartments = rowRecordOfProfile["userAttr"]["department"];

            final isSameOfficeLocation = (currentUserOfficeLocation == userOfficeLocation);
            final isDepartmentMatch = hasBitwiseOverlap(currentUserDepartments, userDepartments);
/*
            final officeLocationMatch = officeLocationFilter == null || userOfficeLocation == officeLocationFilter;
            final departmentsMatch = departmentFilter == null || (userDepartments & departmentFilter) != 0;
*/
            return isSameOfficeLocation && isDepartmentMatch;
          } else {
            debugPrint("## return true ##");
            return true;
          }
        }).toList();
        debugPrint("usersList: ${usersList.toString()}");

        // Update state with filtered users and mark data as ready
        filteredUsers.value = value;
        isLoading.value = false; // Set loading to false after filtering
        hasFilteredData.value = true; // Mark filtered data as available

      });

      return () {};
    }, [asyncUsers, moiProfile.value]);

    // Dialog
    Future<void> openAddUserDialog(BuildContext context, WidgetRef ref) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("ユーザ追加"),
            content: FormBuilder(
              key: GlobalKey<FormBuilderState>(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
/*                          CustomTextFormField(
                            hintText: "名前",
                            controller: tFieldUserNameController,
                            autofocus: true,
                            padding: const EdgeInsets.all(8.0),
                            enabledBorder: const UnderlineInputBorder(),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(),
                            validator: (String? value) => Validations.emptyValidation(value),
                          ), */
                          FormBuilderTextField(
                            name: "名前",
                            controller: tFieldUserNameController,
                            decoration: const InputDecoration(labelText: "名前"),
                            obscureText: false,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                          ),
                          FormBuilderTextField(
                            name: "email",
                            controller: tFieldEmailController,
                            decoration: const InputDecoration(labelText: "メールアドレス"),
                            obscureText: false,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                          ),
                          FormBuilderTextField(
                            name: "password",
                            decoration: const InputDecoration(labelText: "パスワード"),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: tFieldPasswordController,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),
                          FormBuilderTextField(
                            name: "confirmPassword",
                            decoration: const InputDecoration(labelText: "パスワード（確認）"),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'パスワード（確認）は必須です';
                              }
                              if (value.length < 6) {
                                return 'パスワード（確認）は6文字以上である必要があります';
                              }

                              if (value != tFieldPasswordController.text) {
                                return 'パスワードが一致しません';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo[300],
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      formKey.currentState?.saveAndValidate();
                                      //
                                      final displayName = tFieldUserNameController.text;
                                      //final displayName = formKey.currentState?.value["username"];
                                      final email = tFieldEmailController.text;
                                      final password = tFieldPasswordController.text;

                                      // Do signup
                                      try {
                                        final result = await authService.createAccountViaServer(
                                          displayName,
                                          email,
                                          password,
                                        );
                                        /*final result = await authService.createAccountByEmail(
                                          email,
                                          password
                                        ); */
                                        debugPrint("result: ${result}");

                                        // Retreive fcmToken from SecureStorage
                                        String? fcmToken = await storage.read(key: 'fcmToken');

                                        // Store userdata to Firestore "users"
                                        final newUser = FirestoreUser(
                                          username: displayName,
                                          email: email,
                                          password: password,
                                          isOnline: true,
                                          lastActive: DateTime.now(),
                                          accoutStatus: 1, // 1: Online
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );

                                        await userNotifier.addUser(result!, newUser);

                                        // Store fcmToken to "deviceinfo" subcollection of each user
                                        final newDeviceInfo = DeviceInfo(
                                          fcmTokens: {
                                            "token": fcmToken,
                                            "updatedAt": DateTime.now(),
                                          },
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );
                                        await deviceInfoNotifier.addDeviceInfo(result, newDeviceInfo);

                                        // Update displayName
                                        debugPrint(" #### Hppppp   ####");
                                        await authService.updateDisplayName(displayName);

                                        // Store new profile to Firestore "profiles"
                                        final newProfile = Profile(
                                          uid: result,
                                          avatarUrl: [],
                                          userAttr: {
                                            "officeLocation": 0,
                                            "jobLevel": 0,
                                            "department": 0,
                                          },
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );
                                        await profileNotifier.addProfile(result, newProfile);

                                        /* if (context.mounted) {
                                          context.router.replace(const RootRoute());
                                        } */
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(e.toString()))
                                          );
                                        }
                                      }

                                      // ref.invalidate
                                      ref.invalidate(streamUserNotifierProvider);

                                      // Reset form
                                      formKey.currentState?.reset();
                                      tFieldUserNameController.text = "";
                                      tFieldEmailController.text = "";
                                      tFieldPasswordController.text = "";

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("アカウント作成"),
                                  ),
                                )
                              ],
                            ),
                          ),
                ]
              )
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("キャンセル"),
              ),
            ],
          );
        }
      );
    }

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
        title: const Text("ユーザ管理"),
        backgroundColor: Colors.purple[300],
        actions:
          (() {
            if (moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] == 4) {
              return <Widget>[
                IconButton(
                  onPressed: () async {
                    // Add user Dialog
                    await openAddUserDialog(context, ref);
                  },
                  icon: const Icon(Icons.add)
                ),
              ];
            }
          })()
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : hasFilteredData.value
              ? ListView(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: filteredUsers.value.isEmpty
                          ? const Center(child: Text('No data available.'))
                          : DataTable(
                              showCheckboxColumn: false,
                              columns: [
                                moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] == 4
                                ? const DataColumn(label: Text("操作"))
                                : const DataColumn(label: Text(""))
                                ,
                                const DataColumn(label: Text("名前")),
                                const DataColumn(label: Text("アドレス")),
                                const DataColumn(label: Text("支社")),
                                const DataColumn(label: Text("部署名")),
                                const DataColumn(label: Text("役職")),
                              ],
                              rows: filteredUsers.value.map<DataRow>((data) {
                                final rowRecordOfUser = data["user"];
                                final rowRecordOfProfile = data["profile"];
                                debugPrint("###??? rowRecordOfProfile: $rowRecordOfProfile");
                  
                                return DataRow(
                                  cells: [
                                    moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] == 4
                                    ? DataCell(
                                        TextButton(
                                          onPressed: () async {
                                            // Del user confirm dialog
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("ユーザ削除"),
                                                  content: Text("ユーザ ${rowRecordOfUser.username}さんを削除します。よろしいですか？"),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text("キャンセル"),
                                                      onPressed: () async {
                                                        if (context.mounted) {
                                                          context.router.maybePop();
                                                        }
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text("削除", style: TextStyle(color: Colors.red),),
                                                      onPressed: () async {
                  
                                                        // Delete user from Firebase
                                                        await authService.deleteAccount(rowRecordOfProfile["uid"]);
                                                        // Delete user from Firestore
                                                        await userNotifier.deleteUserByUid(rowRecordOfProfile["uid"]);
                  
                                                        // Close modal
                                                        if (context.mounted) {
                                                          context.router.maybePop();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                          },
                                          child: const Text("削除", style: TextStyle(color: Colors.red)),
                                        )
                                      )
                                    : const DataCell(Text(""))
                                    ,
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
                    ),
                ],
              )
              : const Center(child: Text('No data available.')),
    );
  }
}
