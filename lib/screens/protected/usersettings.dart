import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class UserSettings extends HookConsumerWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
//    final authState = ref.watch(firebaseAuthProvider);

    Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
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

    Widget buildLanguage () => DropDownSettingsTile(
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

    return SimpleSettingsTile(
      title: "アプリ個人設定",
      subtitle: "プライバシー, セキュリティ, 言語",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green
        ),
        child: const Icon(Icons.person, color: Colors.white),
      ),
      child: SettingsScreen(
        title: "個人設定",
        children: <Widget>[
          buildAccountInfo(context),
          buildLanguage(),
//          buildPrivacy(context),
//          buildSecurity(context),
        ]
      ),
    );

  }
}