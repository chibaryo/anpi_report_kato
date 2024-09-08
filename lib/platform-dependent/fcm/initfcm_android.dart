import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showAndroidLocalNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher')
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,

    onDidReceiveNotificationResponse:
      (NotificationResponse notificationResponse) async {
        print("id=${notificationResponse.id}");
      }
  );

  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'my_channel_id',
      'my_channel_name'
    ),
  );

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
  );
}