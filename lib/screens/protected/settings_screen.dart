import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as screensettings;
import 'package:url_launcher/url_launcher.dart';

import '../../providers/firebase/isadmin_provider.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/user_provider.dart';
import '../../providers/thememode/themeswitcher_provider.dart';
import 'accountsettings.dart';
import 'usersettings.dart';
import 'notificationadmin.dart';
import 'notitemplates.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyDarkMode = ref.watch(themeSwitcherDataProvider);
    final authState = ref.watch(firebaseAuthProvider);
    final isAdmin = ref.watch(isAdminDataProvider);

      Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo () async {
        final docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(authState.currentUser!.uid)
          .get();

        return docSnapshot;
      }

      Future<void> setDefaultUsername () async {
        await screensettings.Settings.setValue<String>(
          "key-displayname",
          authState.currentUser!.displayName!,
          notify: true
        );
      }

      Future<void> setDefaultPassword (String password) async {
        await screensettings.Settings.setValue<String>(
          "key-password",
          password,
          notify: true
        );
      }

    Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserDocByUid() async {
        final docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(authState.currentUser?.uid)
          .get();
        
        return docSnapshot;
    }


    useEffect((){
      setDefaultUsername().then((value) {
        getUserInfo().then((userInfo) {
          final userInfoData = userInfo.data();
          debugPrint("userInfoData: $userInfoData");
          setDefaultPassword(userInfoData!["password"]);

          // Check if isAdmin
          if (userInfoData["isAdmin"]) {
            ref.read(isAdminDataProvider.notifier).updateState(userInfoData["isAdmin"]);
          }
        });
      });

      return () {};

    }, [authState]);

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
      onTap: () {
//        await screensettings.Settings.clearCache();
        // set flag off
        ref.read(asyncFirebaseUserNotifierProvider.notifier).toggleFirebaseUserOnlineStatus(
          uid: authState.currentUser!.uid,
          isOnlineStatus: false
        ); // toggleFirebaseUserOnlineStatus(

        getUserDocByUid().then((value) {
          final data = value.data();
          final isOnlineStatus = data!['isOnline'];
          debugPrint("user data!['isOnline']: $isOnlineStatus");

          // Logout
          FirebaseAuth.instance.signOut().then((result) {
            // Show snackbar
            const snackBar = SnackBar(
              content: Text("ログアウトしました")
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            context.goNamed("RootScreen");
          });
        });
      }
//      onTap: () => Utils.showSnackBar(context, "Clicked Logout"),
    );

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
    );

    Widget buildReportBug (BuildContext context) => screensettings.SimpleSettingsTile(
      title: "バグを報告する",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal
        ),
        child: const Icon(Icons.bug_report, color: Colors.white),
      ),
      onTap: () => {},
    );

    Widget buildSendFeedback (BuildContext context) => screensettings.SimpleSettingsTile(
      title: "フィードバックする",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple
        ),
        child: const Icon(Icons.thumb_up, color: Colors.white),
      ),
      onTap: () => {},
    );

    Widget buildTerms () => screensettings.SimpleSettingsTile(
      title: "利用規約",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple
        ),
        child: const Icon(Icons.document_scanner_outlined, color: Colors.white),
      ),
      onTap: () {
        final url = Uri.parse('https://chibaryo.github.io/anpi_report_ios/terms/');
        launchUrl(url);
      },
    );

    Widget buildPrivacy () => screensettings.SimpleSettingsTile(
      title: "プライバシーポリシー",
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.cyan
        ),
        child: const Icon(Icons.security_rounded, color: Colors.white),
      ),
      onTap: () {
        final url = Uri.parse('https://chibaryo.github.io/anpi_report_ios/privacy/');
        launchUrl(url);
      },
    );

    Widget buildDarkMode () => screensettings.SwitchSettingsTile(
      settingKey: "key-dark-mode",
//      defaultValue: true,
      enabled: true,
      title: "ダークモード",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF642ef3),
        ),
        child: const Icon(Icons.dark_mode, color: Colors.white),
      ),
      onChange: (_) {
        ref.read(themeSwitcherDataProvider.notifier).setDarkMode(!keyDarkMode);
      },
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            screensettings.SettingsGroup(
              title: "プロフィール編集",
              children: const <Widget>[
                AccountSettings(),
              ]
            ),
            screensettings.SettingsGroup(
              title: "",
              children: <Widget>[
                buildDarkMode(),
              ]
            ),
            if(isAdmin) ...[
            screensettings.SettingsGroup(
              title: "管理",
              children: const <Widget>[
                NotificationAdmins(),
                NotiTemplatesAdmin(),
              ],
            )],
            screensettings.SettingsGroup(
              title: "一般",
              children: <Widget>[
                const UserSettings(),
                buildLogout(),
                buildDeleteAccount(),
              ],
            ),
            screensettings.SettingsGroup(
              title: "利用規約&プライバシーポリシー",
              children: <Widget>[
                buildTerms(),
                buildPrivacy(),
              ],
            ),
            const SizedBox(height: 32,),
            screensettings.SettingsGroup(
              title: "フィードバック",
              children: <Widget>[
                const SizedBox(height: 8,),
                buildReportBug(context),
                buildSendFeedback(context),
              ],
            ),
          ],
        )
      ),
    );
  }
}
