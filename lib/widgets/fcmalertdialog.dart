import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../platform-dependent/fcm/initfcm_ios.dart';
import '../providers/firebaseauth/auth_provider.dart';
import '../providers/firestore/deviceinfotable/deviceinfotable_provider.dart';

class FcmAlertDialog extends HookConsumerWidget {
  const FcmAlertDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
    final iosUDIDNotifier = ref.watch(iOSUdidNotifierProvider);

    return AlertDialog(
            title: const Text("通知許可しますか？"),
            content: const Text("許可してください."),
            actions: <Widget>[
              GestureDetector(
                child: const Text("いいえ"),
                onTap: () async {
                  context.pop();
                }
              ),
              GestureDetector(
                child: const Text("はい"),
                onTap: () {
                  context.pop();
                  if (Platform.isIOS) {
                    initFCMIOS(
                      authState.currentUser!.uid,
                      iosUDIDNotifier
                    );
                  }
                  //await initAndroidFCM(authState.currentUser!.uid);
                }
              ),
            ],
          );
  }
}