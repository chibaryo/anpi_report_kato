import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

const secureStorage = FlutterSecureStorage();
final notiIdProvider = StateProvider<String?>((ref) => null);

Future<void> showAndroidLocalNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher')
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,

    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      final String? receivedNotiId = notificationResponse.payload;

      if (receivedNotiId != null) {
        debugPrint("### Notification clicked! ###");
        debugPrint("receivedNotiId notiId: ${receivedNotiId.toString()}");

        // SecureStorageに保存
        await secureStorage.write(key: "notiId", value: receivedNotiId);
        // Access the provider and update the state
        final container = ProviderContainer();
        final notifier = container.read(notiIdProvider.notifier);
        notifier.state = receivedNotiId;
        // アプリが起動してからページ遷移を行うための処理
        // ここではデータ保存のみを行います
        container.dispose();

      }
    },
  );

/*  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'my_channel_id',
      'my_channel_name'
    ),
  ); */

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'my_channel_id',
      'my_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      ticker: 'ticker',
      number: 1,
    );
  
  const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
  
  debugPrint("fore title: ${message.notification?.title}");
  debugPrint("fore body: ${message.notification?.body}");

  // Send Local Notification
  await flutterLocalNotificationsPlugin.show(
    0, // Notification Id
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: message.data['notificationId'], // Include payload here
  );
}