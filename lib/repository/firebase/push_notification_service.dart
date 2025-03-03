import 'dart:convert';

import 'package:anpi_report_flutter/platform-dependent/fcm/initfcm_android.dart';
import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//final pushNotifications = PushNotificationService();
final String fcmVapidKey = dotenv.get('FIREBASE_FCM_VAPID_KEY'); //"eD8dzYgLNtF4HmmOB9OT3i7Y1G5wXyeeAn4unMBA";

class PushNotificationService {
  final RootStackRouter appRouter;
  final WidgetRef ref;

  PushNotificationService({
    required this.appRouter,
    required this.ref,
  });

  final channel = const AndroidNotificationChannel(
    'fcm_kato_anpi_app_channel', // bd1840df-9ec5-4e69-b237-e4dcb209a310
    'Katosansho Anpi App Notifications',
    description: 'This channel is used for Katosansho Anpi App notifications.',
    importance: Importance.high,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final messaging = FirebaseMessaging.instance;

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    debugPrint("***### Notification clicked! ***");
    Map notificationPayload = jsonDecode(notificationResponse.payload!);
    final notiId = notificationPayload["notificationId"];
    debugPrint("notificationId: ${notificationPayload["notificationId"].toString()}");

    // Navigate to PostEnquetePage
    debugPrint("Navigate to PostEnquetePage...");
    appRouter.push(PostEnqueteRoute(notificationId: notiId));
  }

  void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
    debugPrint('onDidReceiveBackgroundNotificationResponse: $notificationResponse');
  }

  void initializePushNotifications({
    required Future<void> Function(RemoteMessage) handler,
  }) {
    // Set the background handler
    FirebaseMessaging.onBackgroundMessage(handler);

    // Initialize local notifications
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleNotification() async {
    // Terminated: When notification clicked
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      appRouter.push(PostEnqueteRoute(notificationId: initialMessage.data['notificationId']));
    }

    // Background: When notification clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Backgroundで通知からアプリを開きました: ${message.notification?.title}");
      final receivedNotiId = message.data['notificationId'];
      appRouter.push(PostEnqueteRoute(notificationId: receivedNotiId));
    });

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;
      final messageData = message.data;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(messageData),
        );
      }
    });
  }

  Future<void> settingPushNotification() async {
    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getFcmToken() async {
    return await messaging.getToken(vapidKey: fcmVapidKey);
  }
}