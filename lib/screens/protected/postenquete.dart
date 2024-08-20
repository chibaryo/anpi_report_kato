import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../layouts/appbar_header.dart';
import '../../providers/firestore/notification_provider.dart';
import '../../models/notification.dart' as custom_notification;

class PostEnqueteScreen extends HookConsumerWidget {
  final String notiId;
  const PostEnqueteScreen({Key? key, required this.notiId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationFuture = useMemoized(() =>
        ref.read(asyncNotificationNotifierProvider.notifier)
           .fetchNotificationByNotiId(notiId));

    final notificationSnapshot = useFuture(notificationFuture);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 125, 213, 224).withOpacity(0.3),
      appBar: const AppbarHeader(),
      body: notificationSnapshot.connectionState == ConnectionState.waiting
          ? const CircularProgressIndicator()
          : notificationSnapshot.hasData && notificationSnapshot.data != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(color: Colors.white)
                      ),
                      Text(
                        notificationSnapshot.data!.notiTitle,
                        style: const TextStyle(color: Colors.white)
                      ),
                      SizedBox(height: 10),
                      const Text(
                        "Body",
                        style: TextStyle(color: Colors.white)
                      ),
                      Text(
                        notificationSnapshot.data!.notiBody,
                        style: const TextStyle(color: Colors.white)
                      ),
                    ],
                  )
                )
/*              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Title: ${notificationSnapshot.data!.notiTitle}"),
                    Text("Body: ${notificationSnapshot.data!.notiBody}"),
                  ],
                )*/
              : const Text("Notification not found"),
    );
  }
}
