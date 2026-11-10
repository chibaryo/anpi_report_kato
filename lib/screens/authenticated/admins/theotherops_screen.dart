import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/api/account_api_cache.dart';
import '../../../providers/api/me_api_provider.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import '../../../repository/api/me_api_repository.dart';
import '../../../repository/betterauth/session_repository.dart';
import '../../../repository/firebase/authrepo.dart';
import '../../../router/app_router.dart';

@RoutePage()
class TheOtherOpsScreen extends HookConsumerWidget {
  const TheOtherOpsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>('');
    final neonEnabled = SessionRepository.isNeonDataEnabled;
    final userNotifier = neonEnabled
        ? null
        : ref.watch(streamUserNotifierProvider.notifier);
    final neonMe = neonEnabled ? ref.watch(neonMeProvider) : null;
    final AuthService authService = AuthService();
    final meApi = MeApiRepository();
    final passwordController = useTextEditingController();

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });
      if (neonEnabled) {
        final user = neonMe!.asData?.value['user'];
        if (user is Map) {
          moiUid.value = user['id']?.toString() ?? '';
        }
      }
      return () {};
    }, [neonEnabled, neonMe]);

    Future<void> deleteAccountFlow() async {
      if (neonEnabled) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('アカウント削除'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('退会するには現在のパスワードを入力してください。'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'パスワード'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await meApi.deleteAccount(
                        password: passwordController.text,
                      );
                      await AuthService().signOut();
                      invalidateAccountApiProviders(ref);
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      if (context.mounted) {
                        await context.router.root
                            .replaceAll([const SigninRoute()]);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  child: const Text(
                    '削除',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('アカウント削除'),
            content: const Text('アカウント削除します。よろしいですか？'),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () async {
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
              ),
              TextButton(
                child: const Text(
                  '削除',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await userNotifier!.deleteUserByUid(moiUid.value);
                  await authService.deleteAccount(moiUid.value);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (context.mounted) {
                    context.router.replace(const SigninRoute());
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (context.mounted) {
              ref.read(bottomNavNotifierProvider.notifier).show();
              context.router.maybePop();
            }
          },
        ),
        centerTitle: true,
        title: const Text('Anpi'),
        backgroundColor: Colors.purple[300],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      AppSettings.openAppSettings(
                        type: AppSettingsType.notification,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'アプリの通知設定を確認',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: deleteAccountFlow,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'アカウント削除',
                            style: TextStyle(color: Colors.red),
                          ),
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
      ),
    );
  }
}
