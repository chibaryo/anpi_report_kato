
import 'package:anpi_report_flutter/providers/firestore/templates/template_notifier.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/firestoreuser.dart';
import '../../../models/profile.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../repository/firebase/authrepo.dart';
import '../../../router/app_router.dart';

@RoutePage()
class TheOtherOpsScreen extends HookConsumerWidget {
  const TheOtherOpsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final moiProfile = useState<Profile?>(null);
    final moiUser = useState<FirestoreUser?>(null);
    final isLoading = useState<bool>(true); // Track loading status

    final authAsyncValue = ref.watch(authStateChangesProvider);
    final asyncTemplates = ref.watch(streamTemplateNotifierProvider);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final userNotifier = ref.watch(streamUserNotifierProvider.notifier);

    final AuthService authService = AuthService();

    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);

/*
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

    // Load templates from DB
    useEffect(() {

      isLoading.value = false;
    }, [asyncTemplates]); */

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
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // AppSettings
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        AppSettings.openAppSettings(type: AppSettingsType.notification);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("アプリの通知設定を確認", style: TextStyle(color: Colors.blue),),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),                    
                    GestureDetector(
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
                    ),                    
                  ],
                )
              ),
            ),
          ),
        )
    );
  }
}
