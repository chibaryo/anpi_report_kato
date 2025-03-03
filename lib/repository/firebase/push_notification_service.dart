import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final pushNotifications = PushNotificationService();
final String fcmVapidKey = dotenv.get('FIREBASE_FCM_VAPID_KEY'); //"eD8dzYgLNtF4HmmOB9OT3i7Y1G5wXyeeAn4unMBA";

class PushNotificationService {
  final channel = const AndroidNotificationChannel(
    'fcm_kato_anpi_app_channel',
    'Katosansho Anpi App Notifications',
    description: 'This channel is used for Katosansho Anpi App notifications.',
    importance: Importance.high,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final messaging = FirebaseMessaging.instance;

  void initializePushNotifications({
    required Future<void> Function(RemoteMessage) handler,
  }) {
    // バックグラウンドメッセージングハンドラを設定
    FirebaseMessaging.onBackgroundMessage(handler);

    // Androidの通知チャネルを作成
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

  // Androidのみ、アプリを開いている場合にバナーを表示する設定が必要
  void handleNotification({VoidCallback? callbackRouter}) {
    // プッシュ通知を開いた時のハンドリング
    void handleMessage(RemoteMessage message) {}

    // Terminatedから開いた時
    messaging.getInitialMessage();

    // Backgroundから開いた時
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;

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
        );
      }
    });
  }

  Future<void> settingPushNotification() async {
    await _requestPermission();
  }

  Future<void> _requestPermission() async {
    // デフォルト値で権限リクエスト
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getFcmToken() async {
    final fcmToken = await messaging.getToken(
      vapidKey: fcmVapidKey,
    );

    return fcmToken;
  }
}
