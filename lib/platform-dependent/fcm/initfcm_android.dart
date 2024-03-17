import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initAndroidFCM(String uid) async {
  final serverDate = DateTime.now();
  // Init FirebaseAuth
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print("Permission granted: ${settings.authorizationStatus}");
  }

  try {
    // Delete Token
    await messaging.deleteToken();
    // Get token
    final fcmToken = await messaging.getToken(
        vapidKey:
            "BLNDGJO2cAD302-pljCkgSvpVvMkt7atFMJtzG4SYW3SHKSW6aIKMm6AjDJGJ5uAtzRY-dovLXrs5wfbOZ7ZFy0");
    debugPrint("FCM Token: $fcmToken");

    // Save fcmToken to Firestore
    await FirebaseFirestore.instance
      .collection("tokens")
      .doc(uid)
      .update({
        "fcmToken": fcmToken,
        "createdAt": serverDate,
      });

//    final fcmNotifier = ref.read(fcmTokenDataProvider.notifier);
//    fcmNotifier.state = fcmToken!;
    await messaging.subscribeToTopic("notice_all");
//        print("watch: ${ref.watch(fcmTokenDataProvider)}");

//        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // FCM foreground
  } catch (err) {
    throw Exception(err);
  }
}


void showNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id', // チャンネルID
    'your_channel_name', // チャンネル名
//    'your_channel_description', // チャンネルの説明
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
//    icon: "アイコン名",
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(
    0, // 通知ID
    message.data["title"], // 通知のタイトル
    message.data["body"], // 通知の本文
    platformChannelSpecifics,
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();