
import 'package:anpi_report_flutter/providers/firestore/profile/moiProfile_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:flutter_settings_screens/flutter_settings_screens.dart' as screensettings;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../models/profile.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/profile/profile_notifier.dart';

@RoutePage()
class TopicSelectScreen extends HookConsumerWidget {
  const TopicSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsyncValue = ref.watch(authStateChangesProvider);

    final moiUid = useState<String>("");
    final moiProfile = useState<Profile?>(null);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final profileAsyncValue = ref.watch(streamMoiProfileNotifierProvider(moiUid.value));

    final isTokyoFlagOn = useState<bool>(false);
    final isNagoyaFlagOn = useState<bool>(false);
    final isOsakaFlagOn = useState<bool>(false);
    final isHiroshimaFlagOn = useState<bool>(false);
    final isOkayamaFlagOn = useState<bool>(false);
    final isKyushuFlagOn = useState<bool>(false);
    final isTestAdm2024FlagOn = useState<bool>(false);
    final isAdmOnly2025FlagOn = useState<bool>(false);
    const storage = FlutterSecureStorage();


    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Profile stream
        moiProfile.value = profileAsyncValue.asData?.value;
        debugPrint("moiP : ${moiProfile.value.toString()}");
      }

      return () {};
    }, [authAsyncValue, profileAsyncValue]);

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      Future<void> getNotiTopicFlagsFromStorage() async {
        // Tokyo
        final tokyoFlagStr = await storage.read(key: 'tokyoFlagStr');
        debugPrint("tokyoFlagStr: $tokyoFlagStr");
        if (tokyoFlagStr != null && tokyoFlagStr == "on") {
          isTokyoFlagOn.value = true;
        } else {
          isTokyoFlagOn.value = false;
        }
        // Nagoya
        final nagoyaFlagStr = await storage.read(key: 'nagoyaFlagStr');
        if (nagoyaFlagStr != null && nagoyaFlagStr == "on") {
          isNagoyaFlagOn.value = true;
        } else {
          isNagoyaFlagOn.value = false;
        }
        // Osaka
        final osakaFlagStr = await storage.read(key: 'osakaFlagStr');
        if (osakaFlagStr != null && osakaFlagStr == "on") {
          isOsakaFlagOn.value = true;
        } else {
          isOsakaFlagOn.value = false;
        }
        // Hiroshima
        final hiroshimaFlagStr = await storage.read(key: 'hiroshimaFlagStr');
        if (hiroshimaFlagStr != null && hiroshimaFlagStr == "on") {
          isHiroshimaFlagOn.value = true;
        } else {
          isHiroshimaFlagOn.value = false;
        }
        // Okayama
        final okayamaFlagStr = await storage.read(key: 'okayamaFlagStr');
        if (okayamaFlagStr != null && okayamaFlagStr == "on") {
          isOkayamaFlagOn.value = true;
        } else {
          isOkayamaFlagOn.value = false;
        }
        // Kyushu
        final kyushuFlagStr = await storage.read(key: 'kyushuFlagStr');
        if (kyushuFlagStr != null && kyushuFlagStr == "on") {
          isKyushuFlagOn.value = true;
        } else {
          isKyushuFlagOn.value = false;
        }
        // test_adm_2024
        final testadm2024FlagStr = await storage.read(key: 'testadm2024FlagStr');
        debugPrint("testadm2024FlagStr: $testadm2024FlagStr");
        if (testadm2024FlagStr != null && testadm2024FlagStr == "on") {
          isTestAdm2024FlagOn.value = true;
        } else {
          isTestAdm2024FlagOn.value = false;
        }
        // test_adm_2025
        final admOnly2025FlagStr = await storage.read(key: 'admOnly2025FlagStr');
        debugPrint("admOnly2025FlagStr: $admOnly2025FlagStr");
        if (admOnly2025FlagStr != null && admOnly2025FlagStr == "on") {
          isAdmOnly2025FlagOn.value = true;
        } else {
          isAdmOnly2025FlagOn.value = false;
        }
      }

      getNotiTopicFlagsFromStorage();

      return () {};
    }, const []);

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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text("通知_東京"),
                value: isTokyoFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "tokyoFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_tokyo");
                    isTokyoFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 1),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "tokyoFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_tokyo");
                    isTokyoFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 1),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              SwitchListTile(
                title: const Text("通知_名古屋"),
                value: isNagoyaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "nagoyaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_nagoya");
                    isNagoyaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 2),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "nagoyaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_nagoya");
                    isNagoyaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 2),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              SwitchListTile(
                title: const Text("通知_大阪"),
                value: isOsakaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "osakaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_osaka");
                    isOsakaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 3),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "osakaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_osaka");
                    isOsakaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 3),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              SwitchListTile(
                title: const Text("通知_広島"),
                value: isHiroshimaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "hiroshimaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_hiroshima");
                    isHiroshimaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 4),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "hiroshimaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_hiroshima");
                    isHiroshimaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 4),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              SwitchListTile(
                title: const Text("通知_岡山"),
                value: isOkayamaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "okayamaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_okayama");
                    isOkayamaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 5),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "okayamaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_okayama");
                    isOkayamaFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 5),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              SwitchListTile(
                title: const Text("通知_九州"),
                value: isKyushuFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "kyushuFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_kyushu");
                    isKyushuFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 6),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "kyushuFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_kyushu");
                    isKyushuFlagOn.value = value;

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 6),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              ),
              moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] >= 8
              ?
              SwitchListTile(
                title: const Text("管理用テスト2025"),
                value: isAdmOnly2025FlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "admOnly2025FlagStr", value: "on");
                    await messaging.subscribeToTopic("adm_only_2025");
                    isAdmOnly2025FlagOn.value = value;
                    debugPrint("subscriped to : 管理用テスト2025");

                    debugPrint('moiProfile.value?.userAttr s : ${moiProfile.value?.userAttr["subscription"].toString()}');

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) | (1 << 8),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  } else {
                    await storage.write(key: "admOnly2025FlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("adm_only_2025");
                    isAdmOnly2025FlagOn.value = value;
                    debugPrint("Unsubscriped from : 管理用テスト2025");

                    // UpdateProfile for userAttr["subscription"]
                    DateTime now = DateTime.now();
                    final profileUpdates = {
                      "updatedAt": now,
                      "userAttr": {
                        "subscription": (moiProfile.value?.userAttr["subscription"] ?? 0) & ~(1 << 8),
                      },
                    };
                    await profileNotifier.updateProfileByUid(moiUid.value, profileUpdates);
                  }
                }
              )
              : const Text("")
              ,
            ],
          ),
        )
    );
  }
}
