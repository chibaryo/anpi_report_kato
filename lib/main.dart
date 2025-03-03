import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:anpi_report_flutter/repository/firebase/push_notification_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

//import 'platform-dependent/fcm/initfcm_android.dart';
import 'platform-dependent/fcm/initfcm_ios.dart';
import 'providers/firebaseauth/auth_provider.dart';
import 'router/app_router.dart';
import 'screens/authenticated/postenquete_screen.dart';
final Logger logger = Logger();

const secureStorage = FlutterSecureStorage();
final notiIdProvider = StateProvider<String?>((ref) => null);

Future<void> logToFile(String message) async {
  Directory? directory;
  if (Platform.isAndroid) {
    // Get the external cache directory for Android
    final List<Directory>? tempDirs = await getExternalCacheDirectories();
    if (tempDirs != null && tempDirs.isNotEmpty) {
      directory = tempDirs.first; // Assign the first available directory
    } else {
      throw Exception("No cache directory found");
    }
  } else if (Platform.isIOS) {
    // Get the application documents directory for iOS
    directory = await getApplicationDocumentsDirectory();
  } else {
    throw Exception("Unsupported platform");
  }

  if (directory == null) {
    throw Exception("Directory is null");
  }

  final logFile = File('${directory.path}/app.log');

  // Append the log message to the file
  await logFile.writeAsString('$message\n', mode: FileMode.append);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String logMessage = "Hnaddling a background message: ${message.data['notificationId']}";
  logger.i(logMessage);
  await logToFile(logMessage); // Log to file
  await logToFile("message.notification : ${message.notification.toString()})"); // Log to file

  // Increment badge count
  await incrementBadge();
  //await forceBadge();

  //showLocalNotification(message);
}

Future<void> incrementBadge() async {
    String? currentAppBadgeCountStr = await secureStorage.read(key: "currentAppBadgeCount");
  if (currentAppBadgeCountStr != null) {
    final nextAppBadgeCount = int.parse(currentAppBadgeCountStr) + 1;
    await logToFile("nextAppBadgeCount: ${nextAppBadgeCount.toString()}"); // Log to file

    if (Platform.isIOS) {
      if (await FlutterAppBadger.isAppBadgeSupported()) {
          FlutterAppBadger.updateBadgeCount(nextAppBadgeCount); // <-引数の`number`が`null`だった場合は`0`
          // SecureStorageに保存
          await secureStorage.write(key: "currentAppBadgeCount", value: nextAppBadgeCount.toString());
      }
    }
  }
}

Future<void> forceBadge() async {
    if (Platform.isIOS) {
      if (await FlutterAppBadger.isAppBadgeSupported()) {
          FlutterAppBadger.updateBadgeCount(78); // <-引数の`number`が`null`だった場合は`0`
      }
    }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load dotenv file
  await dotenv.load(fileName: ".env");

  // Initialize local notifications
  // Initialize PushNotificationService with router
  final appRouter = AppRouter();
  PushNotificationService().init(router: appRouter);
  PushNotificationService.initLocalNotification();

//  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize PushNotification
/*  pushNotifications.initializePushNotifications(
    handler: _firebaseMessagingBackgroundHandler
  ); */

  // Get fcmToken
//  final fcmToken = await pushNotifications.getFcmToken();
//  debugPrint("Got fcmToken: $fcmToken");

  // Terminated: When notification clicked
/*  RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    debugPrint("Terminatedで通知からアプリを起動しました! ${initialMessage.notification?.title}");
  } */

  // Background: When notification clicked
/*  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("Backgroundで通知からアプリを開きました: ${message.notification?.title}");
  }); */

  // Foreground: When notification received
/*  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint("Foregroundで通知受信 ${message.notification?.title}");
    debugPrint("Foreground 受信データ: ${message.data.toString()}");
    final RemoteNotification? notification = message.notification;
    final messageData = message.data;

    if (messageData['notificationId'] != "") {
      debugPrint("notiId: ${messageData['notificationId']}");
      //      Navigator.pushNamed(context, )
    }
  }); */

//    await messaging.subscribeToTopic("notice_all");

    // Save to secure storage
/*    await secureStorage.write(
      key: "fcmToken",
      value: fcmToken,
    );
    await secureStorage.readAll();
*/

//  await PushNotificationService.initLocalNotification();

  timeago.setLocaleMessages("ja", timeago.JaMessages());

  runApp(ProviderScope(child: MyApp(appRouter: appRouter)));
}

/*
const notiIdStorageKey = "notiId";
final notiIdProvider = StateProvider<String?>((ref) => null);
*/
class MyApp extends HookConsumerWidget {
  final RootStackRouter appRouter;
  MyApp({super.key, required this.appRouter});
//  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final authAsyncValue = ref.watch(authStateChangesProvider);

    final pushNotifications = PushNotificationService();

    // Func defs
    // Local notification
    var initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );


    useEffect(() {
      // Init Push
      PushNotificationService.initializePushNotifications(handler: _firebaseMessagingBackgroundHandler);

      Future.wait(
        [
          // 権限リクエストの設定
          pushNotifications.settingPushNotification(),
          // Handle foreground notification
          pushNotifications.handleNotification(),
        ],
      );

      if (Platform.isAndroid) {
        //
      }

      return null;
    }, const []);

    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      title: "Katosansho Anpi App",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}