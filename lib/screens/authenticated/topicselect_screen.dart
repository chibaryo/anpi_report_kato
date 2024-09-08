
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as screensettings;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../providers/bottomnav/bottomnav_provider.dart';

@RoutePage()
class TopicSelectScreen extends HookConsumerWidget {
  const TopicSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTokyoFlagOn = useState<bool>(false);
    final isNagoyaFlagOn = useState<bool>(false);
    final isOsakaFlagOn = useState<bool>(false);
    final isHiroshimaFlagOn = useState<bool>(false);
    final isOkayamaFlagOn = useState<bool>(false);
    final isKyushuFlagOn = useState<bool>(false);
    const storage = FlutterSecureStorage();

    useEffect(() {
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
      }

      getNotiTopicFlagsFromStorage();
    }, const []);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text("東京"),
                value: isTokyoFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "tokyoFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_tokyo");
                    isTokyoFlagOn.value = value;
                  } else {
                    await storage.write(key: "tokyoFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_tokyo");
                    isTokyoFlagOn.value = value;
                  }
                }
              ),
              SwitchListTile(
                title: const Text("名古屋"),
                value: isNagoyaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "nagoyaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_nagoya");
                    isNagoyaFlagOn.value = value;
                  } else {
                    await storage.write(key: "nagoyaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_nagoya");
                    isNagoyaFlagOn.value = value;
                  }
                }
              ),
              SwitchListTile(
                title: const Text("大阪"),
                value: isOsakaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "osakaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_osaka");
                    isOsakaFlagOn.value = value;
                  } else {
                    await storage.write(key: "osakaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_osaka");
                    isOsakaFlagOn.value = value;
                  }
                }
              ),
              SwitchListTile(
                title: const Text("広島"),
                value: isHiroshimaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "hiroshimaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_hiroshima");
                    isHiroshimaFlagOn.value = value;
                  } else {
                    await storage.write(key: "hiroshimaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_hiroshima");
                    isHiroshimaFlagOn.value = value;
                  }
                }
              ),
              SwitchListTile(
                title: const Text("岡山"),
                value: isOkayamaFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "okayamaFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_okayama");
                    isOkayamaFlagOn.value = value;
                  } else {
                    await storage.write(key: "okayamaFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_okayama");
                    isOkayamaFlagOn.value = value;
                  }
                }
              ),
              SwitchListTile(
                title: const Text("九州"),
                value: isKyushuFlagOn.value,
                onChanged: (bool? value) async {
                  final messaging = FirebaseMessaging.instance;
                  if (value!) {
                    // When true
                    await storage.write(key: "kyushuFlagStr", value: "on");
                    await messaging.subscribeToTopic("notice_kyushu");
                    isKyushuFlagOn.value = value;
                  } else {
                    await storage.write(key: "kyushuFlagStr", value: "off");
                    await messaging.unsubscribeFromTopic("notice_kyushu");
                    isKyushuFlagOn.value = value;
                  }
                }
              ),
            ],
          ),
        )
    );
  }
}
