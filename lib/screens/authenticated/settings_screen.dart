import 'package:anpi_report_flutter/entity/userattr/office_location.dart';
import 'package:anpi_report_flutter/models/firestoreuser.dart';
import 'package:anpi_report_flutter/providers/firebaseauth/auth_provider.dart';
import 'package:anpi_report_flutter/providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/profile/profile_notifier.dart';
import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/userattr/department.dart';
import '../../entity/userattr/joblevel.dart';
import '../../models/profile.dart';

@RoutePage()
class SettingsRouterScreen extends AutoRouter {
  const SettingsRouterScreen({super.key});
}

@RoutePage()
class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final moiUser = useState<FirestoreUser?>(null);
    final moiProfile = useState<Profile?>(null);

    final authAsyncValue = ref.watch(authStateChangesProvider);
    final userNotifier = ref.watch(streamUserNotifierProvider.notifier);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);

    //final AuthService authService = AuthService();

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

/*
    Widget buildDeleteAccount () => screensettings.SimpleSettingsTile(
      title: "アカウント削除",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.pink
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onTap: () => {}, // Utils.showSnackBar(context, "Clicked delete"),
    ); */

/*
    Widget buildLogout () => screensettings.SimpleSettingsTile(
      title: "ログアウト",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent
        ),
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      onTap: () async {
        // Turn the isOnline flag off
        final updates = {
          "isOnline": false
        };
        await userNotifier.updateUserByUid(moiUid.value, updates);
        // SignOut
        await ref.read(firebaseAuthProvider).signOut();
        if (context.mounted) {
          context.router.replace(const SigninRoute());
        }
      }
    ); */


    Widget buildProfilePanel () {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("氏名"),
                const SizedBox(width: 16,),
                moiUser.value != null
                ?
                Text(moiUser.value!.username)
                :
                const Text("")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("アドレス"),
                const SizedBox(width: 16,),
                moiUser.value != null
                ?
                Text(moiUser.value!.email)
                :
                const Text("")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("支社"),
                const SizedBox(width: 16,),
                moiProfile.value != null
                ?
                Text(getOfficeLocationStatusTypeDetailsBySortNumber(moiProfile.value!.userAttr["officeLocation"])?["displayName"])
                :
                const Text("")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("部署名"),
                const SizedBox(width: 16,),
                moiProfile.value != null
                ? Text(
              getDepartmentTypeDetailsBySortNumber(moiProfile.value!.userAttr["department"])
                  .where((dept) => dept['displayName'] != "未設定") // Filter out '未設定'
                  .map((dept) => dept['displayName']) // Extract 'displayName' from each map
                  .join(', ') // Join them into a comma-separated string
                  .isNotEmpty // If there's any valid department, display them
                  ? getDepartmentTypeDetailsBySortNumber(moiProfile.value!.userAttr["department"])
                      .where((dept) => dept['displayName'] != "未設定") // Filter again in case needed
                      .map((dept) => dept['displayName'])
                      .join(', ') 
                  : "未設定", // Otherwise, show "未設定"
                  )
                : const Text(""),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("役職"),
                const SizedBox(width: 16,),
                moiProfile.value != null
                ?
                Text(getJobLevelStatusTypeDetailsBySortNumber(moiProfile.value!.userAttr["jobLevel"])?["displayName"])
                :
                const Text("")
              ],
            ),
          ),
        ],
      );
    }

/*    Widget buildTerms () {
      return const Text("buildTerms");
    }

    Widget buildPrivacy () {
      return const Text("buildPrivacy");
    } */

    Widget buildTemplateAdminButton() {
      return 
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (context.mounted) {
                context.router.push(const TemplateAdminRoute());
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("テンプレート管理"),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("設定"),
          backgroundColor: Colors.purple[300],
          actions: [
            IconButton(
              onPressed: () async {
                // SignOut
                await ref.read(firebaseAuthProvider).signOut();
                if (context.mounted) {
                  context.router.replace(const SigninRoute());
                }
              },
              icon: const Icon(Icons.logout)
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildProfilePanel(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          /*GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              if (context.mounted) {
                                context.router.push(const PlayAdminRoute());
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("あそびば"),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ), */
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              if (context.mounted) {
                                context.router.push(const NotiAdminRoute());
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("通知管理"),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                          buildTemplateAdminButton(),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              if (context.mounted) {
                                context.router.push(const UserAdminRoute());
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ユーザ管理"),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const TopicSelectRoute());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("トピック設定"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    /* GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const NotiAdminRoute());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                        // Turn the isOnline flag off
                        final updates = {
                          "isOnline": false
                        };
                        await userNotifier.updateUserByUid(moiUid.value, updates);
                        // SignOut
                        await ref.read(firebaseAuthProvider).signOut();
                        if (context.mounted) {
                          context.router.replace(const SigninRoute());
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 16,),
                              Text("Log out"),
                            ],))
                      ),
                    ), */
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const TheOtherOpsRoute());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("その他の操作"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const TermsWebViewRoute());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("利用規約"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const PrivacyPolicyWebViewRoute());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("プライバシーポリシー"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if (context.mounted) {
                          context.router.push(const AboutThisAppRoute());
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("このアプリについて"),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
/*                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("アカウント削除"),
                              content: const Text("アカウント削除します。よろしいですか？"),
                              actions: <Widget> [
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
                                    // Delete from firestore
                                    await userNotifier.deleteUserByUid(moiUid.value);

                                    // Delete from FirebaseAuth
                                    await authService.deleteAccount(moiUid.value);

                                    //
                                    if (context.mounted) {
                                      context.router.replace(const SigninRoute());
                                    }
                                  },
                                )
                              ],
                            );
                          }
                        );

                        if (context.mounted) {
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("アカウント削除", style: TextStyle(color: Colors.red),),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ), */
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
