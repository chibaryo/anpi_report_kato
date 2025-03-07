
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/firestoreuser.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/sqlite/users/unansweredusers_sqlite_provider.dart';

@RoutePage()
class PlayAdminScreen extends HookConsumerWidget {
  const PlayAdminScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(unansweredUsersSQLiteNotifierProvider.notifier);

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
          title: const Text("テンプレート管理"),
          backgroundColor: Colors.purple[300],
        ),
        body: Column(
          children: [
ElevatedButton(
      onPressed: () async {
        final user = FirestoreUser(
          username: 'john_doe',
          email: 'john@example.com',
          password: 'password123',
          isOnline: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        try {
          await notifier.addUser('uid123', user);
        } catch (e) {
          //
          //print('Failed to add user: $e');
        }
      },
      child: Text('Add User'),
    ),            
          ],
        )
    );
  }
}
