import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initFCMIOS(String uid, String udid) async {
  debugPrint("### We are in iOS ###");
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
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (kDebugMode) {
    print("Permission granted: ${settings.authorizationStatus}");
  }

  try {
    // Delete Token
    await messaging.unsubscribeFromTopic("notice_all");
    await messaging.deleteToken();
    // Get token
    final fcmToken = await messaging.getToken(
        vapidKey:
            "BHFm_plXBmh3r0yAnBVKjQ8Hg7UXgkyq5sghEKGu2-ZTKYiVxjrR53vo-WwIL-B_9q0ScF5t8Mkj1Ws-dPlLSqI");
    debugPrint("New FCM Token: $fcmToken");

    // Save fcmToken to Firestore
      await FirebaseFirestore.instance
        .collection("tokens")
        .doc(uid)
        .collection("platforms")
        .doc(udid)
        .update({
          "fcmToken": fcmToken,
          "updatedAt": serverDate,
      });
    print("Updated DB");

//    final fcmNotifier = ref.read(fcmTokenDataProvider.notifier);
//    fcmNotifier.state = fcmToken!;
    await messaging.subscribeToTopic("notice_all");
    print("registered to notice_all");
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