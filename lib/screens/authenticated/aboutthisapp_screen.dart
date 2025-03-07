import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/bottomnav/bottomnav_provider.dart';

@RoutePage()
class AboutThisAppScreen extends HookConsumerWidget {
  const AboutThisAppScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
/*    final moiUid = useState<String>("");
    final moiProfile = useState<Profile?>(null);
    final moiUser = useState<FirestoreUser?>(null);

    final isLoading = useState<bool>(true); // Track loading status

    final notifier = ref.read(unansweredUsersSQLiteNotifierProvider.notifier);
*/
    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);


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
          title: const Text("このアプリについて"),
          backgroundColor: Colors.purple[300],
        ),
        body: const Column(
          children: [
            Text("バージョン: v1.2.4(15)"),
            Text("[2025/03/06][v1.2.4] QR認証画面の改修"),
            Text("[2025/03/05][v1.2.3] 通知先トピックの改訂"),
            Text("[2025/03/04][v1.2.2] 通知モジュールの改修"),
            Text("[2025/02/26][v1.2.1] QRコード認証を導入"),
            Text("[2025/02/26][v1.1.9] DataTableの修正"),
            Text("[2025/02/25][v1.1.8] DB定義の修正"),
          ],
        )
    );
  }
}
