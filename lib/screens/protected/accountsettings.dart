import '../../providers/firestore/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../providers/firebaseauth/auth_provider.dart';

final logger = Logger();

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
//    final firebaseUser = ref.watch(asyncFirebaseUserNotifierProvider);

    Widget buildDisplayName () => TextInputSettingsTile(
      title: "氏名変更",
      settingKey: "key-displayname",
      obscureText: false,
//      initialValue: "foo", //authState.currentUser!.displayName!,
      helperText: "input name",
      onChange: (name) async {
        debugPrint("name : $name");
        // Update DisplayName
        await ref.read(asyncFirebaseUserNotifierProvider.notifier).updateFirebaseUserDisplayName(
          uid: authState.currentUser!.uid,
          name: name
        );
        await Settings.setValue<String>(
          "key-displayname",
          name,
//          authState.currentUser!.displayName!,
          notify: true
        );

        // Re-login
        final password = Settings.getValue<String>("key-password");
        await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: authState.currentUser!.email!,
            password: password!,
        );
      },
      validator: (username) => username != null
      ? null
      : "変更後の氏名を入力してください"
    );

    Widget buildPassword () => TextInputSettingsTile(
      title: "パスワード変更",
      settingKey: "key-password",
      obscureText: true,
      onChange: (password) async {
        debugPrint("password: $password");
        await ref.read(asyncFirebaseUserNotifierProvider.notifier).updateFirebaseUserPassword(
          uid: authState.currentUser!.uid,
          password: password,
        );
        await Settings.setValue<String>(
          "key-password",
          password,
//          authState.currentUser!.displayName!,
          notify: true
        );
      },
      validator: (password) => password != null && password.length >= 6
      ? null
      : "パスワードは6文字以上入力してください"
    );

    return SimpleSettingsTile(
      title: authState.currentUser!.displayName!,
      subtitle: authState.currentUser!.email,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green
        ),
        child: const Icon(Icons.person, color: Colors.white),
      ),
      child: SettingsScreen(
        title: "アカウント設定",
        children: <Widget>[
//          buildPrivacy(context),
//          buildSecurity(context),
          buildDisplayName(),
          buildPassword(),
        ]
      ),
    );

  }
}