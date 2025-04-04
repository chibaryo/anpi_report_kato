import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<String?> initFCMIOS(String uid, String udid) async {
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

//    final fcmNotifier = ref.read(fcmTokenDataProvider.notifier);
//    fcmNotifier.state = fcmToken!;
    if (Platform.isAndroid || Platform.isIOS) {
      await messaging.subscribeToTopic("notice_all");
    } else {
      // Web
    }
//        print("watch: ${ref.watch(fcmTokenDataProvider)}");

//        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    return fcmToken;
  } catch (err) {
    throw Exception(err);
  }
}


Future<void> showLocalNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  var initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
/*      onDidReceiveLocalNotification: (id, title, body, payload) async {
        
      },*/
    )
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  var androidDetails = const AndroidNotificationDetails(
      'your_channel_id', // チャンネルID
      'your_channel_name', // チャンネル名
//    'your_channel_description', // チャンネルの説明
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  var iOSDetails = DarwinNotificationDetails();
  var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

  flutterLocalNotificationsPlugin.show(
    0, // 通知ID
    message.data["title"], // 通知のタイトル
    message.data["body"], // 通知の本文
    generalNotificationDetails,
  );
}
