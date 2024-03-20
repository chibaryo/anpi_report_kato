import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:badges/badges.dart';

class AppbarHeader extends HookConsumerWidget implements PreferredSizeWidget {
  const AppbarHeader({Key? key}): super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  AppBar( //isShowAppbar ?
        centerTitle: true,
        backgroundColor: Colors.pink.shade600,
        foregroundColor: Colors.white,
        title: const Text(
          "安否確認"
          //'$pindex'
        ), 
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      );
      // : null,
//    );
  }
}