import 'dart:io';

import 'package:anpi_report_flutter/providers/firestore/profile/moiProfile_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/topictype.dart';
import '../../models/profile.dart';
import '../../providers/api/account_api_cache.dart';
import '../../providers/api/me_api_provider.dart';
import '../../providers/bottomnav/bottomnav_provider.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/profile/profile_notifier.dart';
import '../../repository/api/me_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

// Keys used before the region list became data driven; kept so existing switches survive the update.
const Map<String, String> _legacyStorageKeys = {
  'notice_tokyo': 'tokyoFlagStr',
  'notice_nagoya': 'nagoyaFlagStr',
  'notice_osaka': 'osakaFlagStr',
  'notice_hiroshima': 'hiroshimaFlagStr',
  'notice_okayama': 'okayamaFlagStr',
  'notice_kyushu': 'kyushuFlagStr',
  'adm_only_2025': 'admOnly2025FlagStr',
};

String _storageKeyFor(TopicType t) => _legacyStorageKeys[t.topic] ?? '${t.topic}FlagStr';

String _regionLabel(TopicType t) => t.displayName.replaceFirst('通知_', '');

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

    final enabledTopics = useState<Set<String>>(<String>{});
    final busyTopic = useState<String?>(null);
    const storage = FlutterSecureStorage();
    final meApi = MeApiRepository();

    final isAdmin = ((moiProfile.value?.userAttr['jobLevel'] as num?)?.toInt() ?? 0) >= 4;
    final visibleTopics = <TopicType>[
      ...selectableRegionTopics,
      if (isAdmin) TopicType.candidateAdmOnly2025,
    ];

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

    // Device-local flags first, so the screen is usable before the profile loads.
    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      Future<void> readFlags() async {
        final on = <String>{};
        for (final t in [...selectableRegionTopics, TopicType.candidateAdmOnly2025]) {
          if (await storage.read(key: _storageKeyFor(t)) == 'on') on.add(t.topic);
        }
        enabledTopics.value = on;
      }

      readFlags();
      return () {};
    }, const []);

    // The account's bitmask wins once known: it also reflects changes made from the web.
    final subscription = (moiProfile.value?.userAttr['subscription'] as num?)?.toInt();
    useEffect(() {
      if (subscription == null) return () {};
      enabledTopics.value = {
        for (final t in [...selectableRegionTopics, TopicType.candidateAdmOnly2025])
          if ((subscription & t.bitMaskNum) != 0) t.topic,
      };
      return () {};
    }, [subscription]);

    Future<void> persistSubscription(Set<String> topics, TopicType changed, bool enabled) async {
      final current = (moiProfile.value?.userAttr['subscription'] as num?)?.toInt() ?? 0;
      final next = enabled ? (current | changed.bitMaskNum) : (current & ~changed.bitMaskNum);
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
          topics: ['notice_all', ...topics],
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

    Future<void> toggleTopic(TopicType t, bool value) async {
      if (busyTopic.value != null) return;
      busyTopic.value = t.topic;
      final messaging = FirebaseMessaging.instance;
      final next = {...enabledTopics.value};
      try {
        if (value) {
          await messaging.subscribeToTopic(t.topic);
          next.add(t.topic);
        } else {
          await messaging.unsubscribeFromTopic(t.topic);
          next.remove(t.topic);
        }
        await storage.write(key: _storageKeyFor(t), value: value ? 'on' : 'off');
        enabledTopics.value = next;
        await persistSubscription(next, t, value);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('設定の保存に失敗しました。通信状況を確認してください。')),
          );
        }
      } finally {
        busyTopic.value = null;
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
        title: const Text('通知受信設定'),
        backgroundColor: Colors.purple[300],
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '地震の自動通知など、地域ごとの通知を受け取るかを選びます。全体通知は常に受け取ります。',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const ListTile(
            title: Text('全体'),
            trailing: Text('常に受信', style: TextStyle(color: Colors.black54)),
          ),
          const Divider(height: 1),
          for (final t in visibleTopics)
            SwitchListTile(
              title: Text(_regionLabel(t)),
              value: enabledTopics.value.contains(t.topic),
              onChanged: busyTopic.value == null ? (value) => toggleTopic(t, value) : null,
            ),
        ],
      ),
    );
  }
}
