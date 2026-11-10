import 'dart:io';

import 'package:anpi_report_flutter/providers/firestore/profile/moiProfile_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/profile.dart';
import '../../providers/api/account_api_cache.dart';
import '../../providers/api/me_api_provider.dart';
import '../../providers/bottomnav/bottomnav_provider.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/profile/profile_notifier.dart';
import '../../repository/api/me_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

@RoutePage()
class TopicSelectScreen extends HookConsumerWidget {
  const TopicSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neonEnabled = SessionRepository.isNeonDataEnabled;
    final authAsyncValue = neonEnabled
        ? const AsyncValue.data(null)
        : ref.watch(authStateChangesProvider);
    final neonMe = neonEnabled ? ref.watch(neonMeProvider) : null;
    final neonProfile = neonEnabled ? ref.watch(neonMoiProfileProvider) : null;

    final moiUid = useState<String>('');
    final moiProfile = useState<Profile?>(null);
    final profileNotifier = neonEnabled
        ? null
        : ref.watch(streamProfileNotifierProvider.notifier);
    final profileAsyncValue = neonEnabled
        ? null
        : ref.watch(streamMoiProfileNotifierProvider(moiUid.value));

    final isTokyoFlagOn = useState<bool>(false);
    final isNagoyaFlagOn = useState<bool>(false);
    final isOsakaFlagOn = useState<bool>(false);
    final isHiroshimaFlagOn = useState<bool>(false);
    final isOkayamaFlagOn = useState<bool>(false);
    final isKyushuFlagOn = useState<bool>(false);
    final isTestAdm2024FlagOn = useState<bool>(false);
    final isAdmOnly2025FlagOn = useState<bool>(false);
    const storage = FlutterSecureStorage();
    final meApi = MeApiRepository();

    useEffect(() {
      if (neonEnabled) {
        moiProfile.value = neonProfile?.asData?.value;
        final user = neonMe!.asData?.value['user'];
        if (user is Map) {
          moiUid.value = user['id']?.toString() ?? '';
        }
        return () {};
      }
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        moiProfile.value = profileAsyncValue?.asData?.value;
      }
      return () {};
    }, [authAsyncValue, profileAsyncValue, neonEnabled, neonMe, neonProfile]);

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      Future<void> getNotiTopicFlagsFromStorage() async {
        Future<bool> readFlag(String key) async {
          final value = await storage.read(key: key);
          return value == 'on';
        }

        isTokyoFlagOn.value = await readFlag('tokyoFlagStr');
        isNagoyaFlagOn.value = await readFlag('nagoyaFlagStr');
        isOsakaFlagOn.value = await readFlag('osakaFlagStr');
        isHiroshimaFlagOn.value = await readFlag('hiroshimaFlagStr');
        isOkayamaFlagOn.value = await readFlag('okayamaFlagStr');
        isKyushuFlagOn.value = await readFlag('kyushuFlagStr');
        isTestAdm2024FlagOn.value = await readFlag('testadm2024FlagStr');
        isAdmOnly2025FlagOn.value = await readFlag('admOnly2025FlagStr');
      }

      getNotiTopicFlagsFromStorage();
      return () {};
    }, const []);

    Future<void> persistSubscriptionBit({
      required int bit,
      required bool enabled,
    }) async {
      final current = moiProfile.value?.userAttr['subscription'] as int? ?? 0;
      final next = enabled ? (current | (1 << bit)) : (current & ~(1 << bit));
      if (neonEnabled) {
        final response = await meApi.patchProfile(
          userAttr: {'subscription': next},
        );
        final user = response['user'];
        if (user is Map) {
          final attr = user['user_attr'];
          moiProfile.value = Profile(
            uid: user['id']?.toString() ?? moiUid.value,
            userAttr: attr is Map
                ? Map<String, dynamic>.from(attr)
                : <String, dynamic>{'subscription': next},
          );
        } else {
          moiProfile.value = Profile(
            uid: moiUid.value,
            userAttr: {
              ...(moiProfile.value?.userAttr ?? {}),
              'subscription': next,
            },
          );
        }
        invalidateAccountApiProviders(ref);

        final fcmToken = await storage.read(key: 'fcmToken');
        final topics = <String>['notice_all'];
        if (isTokyoFlagOn.value) topics.add('notice_tokyo');
        if (isNagoyaFlagOn.value) topics.add('notice_nagoya');
        if (isOsakaFlagOn.value) topics.add('notice_osaka');
        if (isHiroshimaFlagOn.value) topics.add('notice_hiroshima');
        if (isOkayamaFlagOn.value) topics.add('notice_okayama');
        if (isKyushuFlagOn.value) topics.add('notice_kyushu');
        if (isAdmOnly2025FlagOn.value) topics.add('adm_only_2025');

        String udid = 'unknown';
        try {
          final deviceInfo = DeviceInfoPlugin();
          if (Platform.isAndroid) {
            final android = await deviceInfo.androidInfo;
            udid = android.id;
          } else if (Platform.isIOS) {
            final ios = await deviceInfo.iosInfo;
            udid = ios.identifierForVendor ?? 'unknown';
          }
        } catch (_) {}

        await SessionRepository().registerDevice(
          udid: udid,
          platform: Platform.isIOS ? 'ios' : 'android',
          fcmToken: fcmToken,
          topics: topics,
        );
        return;
      }

      await profileNotifier!.updateProfileByUid(moiUid.value, {
        'updatedAt': DateTime.now(),
        'userAttr': {'subscription': next},
      });
      moiProfile.value = Profile(
        uid: moiUid.value,
        userAttr: {
          ...(moiProfile.value?.userAttr ?? {}),
          'subscription': next,
        },
      );
    }

    Future<void> toggleTopic({
      required bool? value,
      required ValueNotifier<bool> flag,
      required String storageKey,
      required String topic,
      required int bit,
    }) async {
      if (value == null) return;
      final messaging = FirebaseMessaging.instance;
      if (value) {
        await storage.write(key: storageKey, value: 'on');
        await messaging.subscribeToTopic(topic);
        flag.value = true;
        await persistSubscriptionBit(bit: bit, enabled: true);
      } else {
        await storage.write(key: storageKey, value: 'off');
        await messaging.unsubscribeFromTopic(topic);
        flag.value = false;
        await persistSubscriptionBit(bit: bit, enabled: false);
      }
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('通知_東京'),
              value: isTokyoFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isTokyoFlagOn,
                storageKey: 'tokyoFlagStr',
                topic: 'notice_tokyo',
                bit: 1,
              ),
            ),
            SwitchListTile(
              title: const Text('通知_名古屋'),
              value: isNagoyaFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isNagoyaFlagOn,
                storageKey: 'nagoyaFlagStr',
                topic: 'notice_nagoya',
                bit: 2,
              ),
            ),
            SwitchListTile(
              title: const Text('通知_大阪'),
              value: isOsakaFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isOsakaFlagOn,
                storageKey: 'osakaFlagStr',
                topic: 'notice_osaka',
                bit: 3,
              ),
            ),
            SwitchListTile(
              title: const Text('通知_広島'),
              value: isHiroshimaFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isHiroshimaFlagOn,
                storageKey: 'hiroshimaFlagStr',
                topic: 'notice_hiroshima',
                bit: 4,
              ),
            ),
            SwitchListTile(
              title: const Text('通知_岡山'),
              value: isOkayamaFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isOkayamaFlagOn,
                storageKey: 'okayamaFlagStr',
                topic: 'notice_okayama',
                bit: 5,
              ),
            ),
            SwitchListTile(
              title: const Text('通知_九州'),
              value: isKyushuFlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isKyushuFlagOn,
                storageKey: 'kyushuFlagStr',
                topic: 'notice_kyushu',
                bit: 6,
              ),
            ),
            SwitchListTile(
              title: const Text('管理用テスト2025'),
              value: isAdmOnly2025FlagOn.value,
              onChanged: (value) => toggleTopic(
                value: value,
                flag: isAdmOnly2025FlagOn,
                storageKey: 'admOnly2025FlagStr',
                topic: 'adm_only_2025',
                bit: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
