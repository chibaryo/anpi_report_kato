import 'package:anpi_report_ios/entity/userattr/office_location.dart';
import 'package:anpi_report_ios/models/firestoreuser.dart';
import 'package:anpi_report_ios/providers/firebaseauth/auth_provider.dart';
import 'package:anpi_report_ios/providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import 'package:anpi_report_ios/providers/firestore/notification/notification_notifier.dart';
import 'package:anpi_report_ios/providers/firestore/profile/profile_notifier.dart';
import 'package:anpi_report_ios/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entity/userattr/department.dart';
import '../../entity/userattr/joblevel.dart';
import '../../models/notification/notification.dart';
import '../../models/profile.dart';
import 'admins/notiadmin_screen.dart';
import 'topicselect_screen.dart';

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

    final notificationNotifier = ref.watch(streamNotificationNotifierProvider.notifier);
    final authAsyncValue = ref.watch(authStateChangesProvider);
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
                  .map((dept) => dept['displayName']) // Extract 'displayName' from each map
                  .join(', ') // Join them into a comma-separated string
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

    Widget buildTerms () {
      return const Text("buildTerms");
    }

    Widget buildPrivacy () {
      return const Text("buildPrivacy");
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("設定"),
          backgroundColor: Colors.purple[300],
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
                    GestureDetector(
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
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
