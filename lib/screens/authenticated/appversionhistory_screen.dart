import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/bottomnav/bottomnav_provider.dart';

final listVersionHistory = [
  {
    "date": "[2025/03/12]",
    "version": "1.3.1",
    "description": "生体認証でログイン履歴から自動ログイン機能を実装",
  },
  {
    "date": "[2025/03/12]",
    "version": "1.3.0",
    "description": "西日本統括（支社扱い）を新設",
  },
  {
    "date": "[2025/03/12]",
    "version": "1.2.9",
    "description": "サインアップ画面でのQR認証バイパス修正",
  },
  {
    "date": "[2025/03/11]",
    "version": "1.2.8",
    "description": "サインイン後はQR認証をバイパスする",
  },
  {
    "date": "[2025/03/11]",
    "version": "1.2.7",
    "description": "通知トピックに基づくフィルタリング",
  },
  {
    "date": "[2025/03/06]",
    "version": "1.2.4",
    "description": "QR認証画面の改修",
  },
  {
    "date": "[2025/03/05]",
    "version": "1.2.3",
    "description": "通知先トピックの改訂",
  },
  {
    "date": "[2025/03/04]",
    "version": "1.2.2",
    "description": "通知モジュールの改修",
  },
  {
    "date": "[2025/02/26]",
    "version": "1.2.1",
    "description": "QRコード認証を導入",
  },
  {
    "date": "[2025/02/26]",
    "version": "1.1.9",
    "description": "DataTableの修正",
  },
  {
    "date": "[2025/02/25]",
    "version": "1.1.8",
    "description": "DB定義の修正",
  },
];

@RoutePage()
class AppVersionHistroyScreen extends HookConsumerWidget {
  const AppVersionHistroyScreen({super.key});

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
              //ref.read(bottomNavNotifierProvider.notifier).show();
              context.router.maybePop();
            }
          },
        ),
        centerTitle: true,
        title: const Text("バージョン履歴"),
        backgroundColor: Colors.purple[300],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: const [
                          DataColumn(label: Text("日付")),
                          DataColumn(label: Text("バージョン")),
                          DataColumn(label: Text("修正項目")),
                        ],
                        rows: listVersionHistory.map((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Text(entry["date"] ?? "")),
                              DataCell(Text(entry["version"] ?? "")),
                              DataCell(Text(entry["description"] ?? "")),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
