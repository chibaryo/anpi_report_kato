import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../repository/betterauth/session_repository.dart';

class AppVersionGate extends HookConsumerWidget {
  const AppVersionGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOutdated = useState(false);
    final isChecking = useState(true);

    Future<void> checkMinVersion() async {
      isChecking.value = true;
      try {
        final info = await PackageInfo.fromPlatform();
        final outdated = await SessionRepository().isAppOutdated(
          version: info.version,
          build: int.tryParse(info.buildNumber) ?? 0,
        );
        isOutdated.value = outdated;
      } catch (_) {
        isOutdated.value = false;
      } finally {
        isChecking.value = false;
      }
    }

    useEffect(() {
      checkMinVersion();
      return null;
    }, const []);

    if (!isOutdated.value) {
      return child;
    }

    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 48, color: Colors.purple),
                const SizedBox(height: 16),
                const Text(
                  'アプリの更新が必要です',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'セキュリティ対応のため、新しいアプリをインストールしてください。',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isChecking.value ? null : checkMinVersion,
                  child: Text(isChecking.value ? '確認中...' : '再確認'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
