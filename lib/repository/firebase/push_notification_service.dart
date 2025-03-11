import 'dart:convert';
import 'dart:io';

import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';

//final pushNotifications = PushNotificationService();
final String fcmVapidKey = dotenv.get('FIREBASE_FCM_VAPID_KEY'); //"eD8dzYgLNtF4HmmOB9OT3i7Y1G5wXyeeAn4unMBA";

class PushNotificationService {
  // Singleton instance
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;

  late final RootStackRouter appRouter; // Use `late` to initialize it in `init()`

  // Private constructor
  PushNotificationService._internal();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'fcm_kato_anpi_app_channel',
    'Katosansho Anpi App Notifications',
    description: 'This channel is used for Katosansho Anpi App notifications.',
    importance: Importance.high,
  );

  /// Initialize the service with dependencies (appRouter)
  void init({required RootStackRouter router}) {
    appRouter = router;
  }

  static Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    ); 

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    if (Platform.isAndroid) {
      await requestAndroidPermissions();
    }
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    debugPrint("***### Notification clicked! ***");
    Map notificationPayload = jsonDecode(notificationResponse.payload!);
    final notiId = notificationPayload["notificationId"];
    debugPrint("notificationId: ${notificationPayload["notificationId"].toString()}");

    debugPrint("Navigate to PostEnquetePage...");
    _instance.appRouter.push(PostEnqueteRoute(notificationId: notiId)); // No need for `?`
  }

  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
    debugPrint('onDidReceiveBackgroundNotificationResponse: $notificationResponse');
  }

  static Future<void> requestAndroidPermissions() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final androidOsVersion = androidInfo.version.release;
    debugPrint("androidOsVersion : ## ${androidOsVersion.toString()}");

    // Resolve the Android-specific implementation of the notifications plugin
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

    // Request notification permissions
    await androidImplementation?.requestNotificationsPermission();
  }

  static void initializePushNotifications({
    required Future<void> Function(RemoteMessage) handler,
  }) {
    // Set the background handler
    FirebaseMessaging.onBackgroundMessage(handler);

/*    // Initialize local notifications
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel); */

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> handleNotification() async {
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      appRouter.push(PostEnqueteRoute(notificationId: initialMessage.data['notificationId']));
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final receivedNotiId = message.data['notificationId'];
      appRouter.push(PostEnqueteRoute(notificationId: receivedNotiId));
    });

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
      } else if (notification != null && android == null) {
        // in iOS foreground
        debugPrint("iOS foreground message ...");
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

  Future<void> subscribeToNoticeAll() async {
    return await messaging.subscribeToTopic("notice_all");
  }
}
