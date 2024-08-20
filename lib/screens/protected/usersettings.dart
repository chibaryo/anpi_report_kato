import 'package:anpi_report_ios/providers/firestore/deviceinfotable/deviceinfotable_provider.dart';
import 'package:anpi_report_ios/providers/geolocator/location_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as screensettings;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../providers/firestore/deviceinfotable/fcmtoken_provider.dart';

final logger = Logger();

class UserSettings extends HookConsumerWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uDID = ref.watch(udidNotifierProvider);
    final fcmToken = ref.watch(fcmTokenNotifierProvider);
//    final authState = ref.watch(firebaseAuthProvider);
    useEffect(() {
      debugPrint("udID: $uDID");
      debugPrint("fcmToken: $fcmToken");

      return () {};
    }, const []);

    Widget buildLocationPermission(String title, String topic) => screensettings.SwitchSettingsTile(
      settingKey: "key-locationpermission-$title",
      enabled: true,
      title: title,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF642ef3),
        ),
        child: const Icon(Icons.map_outlined, color: Colors.white),
      ),
      onChange: (value) async {
        final messaging = FirebaseMessaging.instance;
        debugPrint("value: $value");
        if (value == true) {
          await messaging.subscribeToTopic("notice_$topic");
        } else if (value == false) {
          await messaging.unsubscribeFromTopic("notice_$topic");
        }
      },
    );


    Widget buildAccountInfo(BuildContext context) => screensettings.SimpleSettingsTile(
      title: 'アカウント情報編集',
      subtitle: "",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal
        ),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      onTap: () => {},
    );

    Widget buildLanguage () => screensettings.DropDownSettingsTile(
      settingKey: "key-language",
      title: "言語設定",
      subtitle: "",
      selected: 1,
      values: const <int, String> {
        1: "日本語",
        4: "English",
        2: "中文",
        3: "한국어",
      },
      onChange: (language) {
        /* NOOP */
      },
    );

    Widget buildFCMTokenChange () => screensettings.SimpleSettingsTile(
      title: "FCMトークン",
      subtitle: fcmToken,
      onTap: () => {},
    );

    return screensettings.SimpleSettingsTile(
      title: "個人設定",
      subtitle: "言語、トピック",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green
        ),
        child: const Icon(Icons.person, color: Colors.white),
      ),
      child: screensettings.SettingsScreen(
        title: "個人設定",
        children: <Widget>[
          //buildAccountInfo(context),
          //buildLanguage(),
          buildLocationPermission("東京", "tokyo"),
          buildLocationPermission("名古屋", "nagoya"),
          buildLocationPermission("大阪", "osaka"),
          buildLocationPermission("広島", "hiroshima"),
          buildLocationPermission("岡山", "okayama"),
          buildLocationPermission("九州", "kyushu"),
          buildFCMTokenChange(),
//          buildPrivacy(context),
//          buildSecurity(context),
        ]
      ),
    );

  }
}