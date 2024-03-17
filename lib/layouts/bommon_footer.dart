import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/bottomnav/bottomnav_provider.dart';

//final pindexProvider = StateProvider<int>((ref) => 0);

class BottomNavFooter extends HookConsumerWidget {
  const BottomNavFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectIndex = ref.watch(bottomNavNotifierProvider);

    void onItemTapped(int index) {
      ref.read(bottomNavNotifierProvider.notifier).state = index;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
