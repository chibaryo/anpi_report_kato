import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:wayo_chatapp/layouts/sidenav/navcontents.dart';

import '../providers/bottomnav/bottomnav_provider.dart';
import '../screens/protected/homescreen.dart';
import '../screens/protected/settings_screen.dart';
import 'appbar_header.dart';
import 'bommon_footer.dart';

class CommonBaseLayout extends HookConsumerWidget implements PreferredSizeWidget {
  const CommonBaseLayout({required this.body, Key? key}): super(key: key);
  final Widget body;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectIndex = ref.watch(bottomNavNotifierProvider);

    const List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: const AppbarHeader(),
//      drawer: const NavContents(),
      body: Center(
        child: widgetOptions.elementAt(selectIndex), //Text(selectIndex.toString()),
      ),
      bottomNavigationBar: const BottomNavFooter()
    );
  }
  
}
