import 'package:anpi_report_flutter/screens/authenticated/appversionhistory_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../router/app_router.dart';

@RoutePage()
class AboutThisAppRouterScreen extends AutoRouter {
  const AboutThisAppRouterScreen({super.key});
}

@RoutePage()
class AboutThisAppScreen extends HookConsumerWidget {
  const AboutThisAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {};
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("バージョン"),
                        Text("v1.2.8"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (context.mounted) {
                        context.router.push(const AppVersionHistroyRoute());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("履歴"),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      /*const Column(
          children: [
            Text("バージョン: v1.2.7(15)"),
            Text("[2025/03/11][v1.2.7] 通知トピックに基づくフィルタリング"),
            Text("[2025/03/06][v1.2.4] QR認証画面の改修"),
            Text("[2025/03/05][v1.2.3] 通知先トピックの改訂"),
            Text("[2025/03/04][v1.2.2] 通知モジュールの改修"),
            Text("[2025/02/26][v1.2.1] QRコード認証を導入"),
            Text("[2025/02/26][v1.1.9] DataTableの修正"),
            Text("[2025/02/25][v1.1.8] DB定義の修正"),
          ],
        )*/
    );
  }
}
