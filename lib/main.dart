import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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
import 'router/app_router.dart';
import 'screens/authenticated/postenquete_screen.dart';
final Logger logger = Logger();

const secureStorage = FlutterSecureStorage();

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

  String logMessage = "ハンドリング a background message: ${message.data['notificationId']}";
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

  // Init FCM
  final messaging = FirebaseMessaging.instance;
  final fcmSettings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (kDebugMode) {
    print("FCM Permission granted: ${fcmSettings.authorizationStatus}");
  }
  try {
    final fcmToken = await messaging.getToken(
      vapidKey: "BHFm_plXBmh3r0yAnBVKjQ8Hg7UXgkyq5sghEKGu2-ZTKYiVxjrR53vo-WwIL-B_9q0ScF5t8Mkj1Ws-dPlLSqI",
    );
    // Print fcmToken
    debugPrint("Got fcmToken: $fcmToken");
    // Subscribe to "notice_all" (default)
    await messaging.subscribeToTopic("notice_all");

    // Save to secure storage
    await secureStorage.write(
      key: "fcmToken",
      value: fcmToken,
    );
    await secureStorage.readAll();

  } catch (err) {
    throw Exception(err);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  timeago.setLocaleMessages("ja", timeago.JaMessages());
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

const notiIdStorageKey = "notiId";

final notiIdProvider = StateProvider<String?>((ref) => null);

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notiId = ref.watch(notiIdProvider);
    final isNotiClicked = useState<bool>(false);

    // Func defs
    Future<void> showIosLocalNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  var initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
/*      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print("payload: $payload");
        print("id: $id");
                // SecureStorageに保存
        //await secureStorage.write(key: "notiId", value: receivedNotiId);
        // Access the provider and update the state
        //ref.read(notiIdProvider.notifier).state = receivedNotiId;
      }, */
    )
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        debugPrint("***### Notification clicked! ***");
        Map notificationPayload =
          (jsonDecode(notificationResponse.payload!));
        debugPrint("notificationId: ${notificationPayload["notificationId"].toString()}");
      final String? receivedNotiId = notificationPayload["notificationId"];
      if (receivedNotiId != null) {
        debugPrint("receivedNotiId notiId: $receivedNotiId");
        ref.read(notiIdProvider.notifier).state = receivedNotiId;
        isNotiClicked.value = true;
      }
    }
  );

  var androidDetails = const AndroidNotificationDetails(
      'your_channel_id', // チャンネルID
      'your_channel_name', // チャンネル名
//    'your_channel_description', // チャンネルの説明
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  var iOSDetails = const DarwinNotificationDetails();
  var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

  flutterLocalNotificationsPlugin.show(
    0, // 通知ID
    message.notification?.title,
    message.notification?.body,
    generalNotificationDetails,
    payload: jsonEncode(message.data),
  );
}

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
        debugPrint("*** Notification clicked! ****");
        debugPrint("receivedNotiId notiId: ${receivedNotiId.toString()}");

        // SecureStorageに保存
        await secureStorage.write(key: "notiId", value: receivedNotiId);
        // Access the provider and update the state
        ref.read(notiIdProvider.notifier).state = receivedNotiId;
        isNotiClicked.value = true;
        debugPrint("### isNotiCliced フラグをONにしました ###");
        // アプリが起動してからページ遷移を行うための処理
        // ここではデータ保存のみを行います
      }
    },
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
    payload: jsonEncode(message.data),
    //payload: message.data['notificationId'], // Include payload here
  );
}    // End func defs

    final appRouter = AppRouter(); //ref.watch(appRouterProvider);// appRouterProviderは、ルーティングの設定を管理する

    useEffect(() {
      Future<void> storeNotiIdToSecureStorage (String notiId) async {
        await secureStorage.write(key: notiIdStorageKey, value: notiId);
      }
      // Handle foreground notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint("### onMessage has come ### : ${message.toString()}");
    inspect(message);
    if (Platform.isAndroid) {
      showAndroidLocalNotification(message);
    } else if (Platform.isIOS) {
      showIosLocalNotification(message);
    }

    final receivedNotiId = message.data['notificationId'];
  if (receivedNotiId != null) {
    // Navigate to a new route or update the UI based on the notification
    ref.read(notiIdProvider.notifier).state = receivedNotiId;

    // Optionally, clear the notification ID from SecureStorage if needed
    secureStorage.delete(key: "notiId");
  }
  });

      // Handle app opened from notification (in background or foreground)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final receivedNotiId = message.data['notificationId'];
    if (receivedNotiId != null) {
      debugPrint("### App opened from notification ###: ${message.toString()}");

      storeNotiIdToSecureStorage(receivedNotiId).then((_) {
        debugPrint("store noti id to storage:");
        ref.read(notiIdProvider.notifier).state = receivedNotiId;
        isNotiClicked.value = true;

        // Navigate to PostEnqueteRoute on notification click
/*        WidgetsBinding.instance.addPostFrameCallback((_) {
          final appRouter = ref.read(appRouterProvider);
          appRouter.push(PostEnqueteRoute(notificationId: receivedNotiId));
        }); */
      });
    }
  });

      // Handle app launched from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
          //appRouter.replaceAll([PostEnqueteRoute(notificationId: "176fc56e-9ab6-44f5-9517-e0cc88a32619")]);

    if (message != null) {
      logToFile("message not null : ${message.data['notificationId']}").then((value) {
      final receivedNotiId = message.data['notificationId'];
      if (receivedNotiId != null) {
        debugPrint("### App launched from notification ###: ${message.toString()}");
 
        storeNotiIdToSecureStorage(receivedNotiId).then((_) {
          ref.read(notiIdProvider.notifier).state = receivedNotiId;
          debugPrint("### notiId: (getInitialMessage) ### $notiId");
          //appRouter.replaceAll([const RootRoute()]);
          appRouter.push(PostEnqueteRoute(notificationId: receivedNotiId));
          //appRouter.replaceAll([PostEnqueteRoute(notificationId: "176fc56e-9ab6-44f5-9517-e0cc88a32619")]);
          // isNotiClicked.value = true;
        });
      }
      });

      final receivedNotiId = message.data['notificationId'];
/*      if (receivedNotiId != null) {
        debugPrint("### App launched from notification ###: ${message.toString()}");

        storeNotiIdToSecureStorage(receivedNotiId).then((_) {
          ref.read(notiIdProvider.notifier).state = receivedNotiId;
          debugPrint("### notiId: ### $notiId");
          appRouter.replaceAll([const RootRoute()]);
          //appRouter.replaceAll([PostEnqueteRoute(notificationId: receivedNotiId)]);
          //appRouter.replaceAll([PostEnqueteRoute(notificationId: "176fc56e-9ab6-44f5-9517-e0cc88a32619")]);
          // isNotiClicked.value = true;
        });
      } */
    }

  });
      return () {};
    }, const []);


    useEffect(() {
      if (notiId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isNotiClicked.value) {
            appRouter.push(PostEnqueteRoute(notificationId: notiId));
          }
          ref.read(notiIdProvider.notifier).state = null; // Reset the ID
          isNotiClicked.value = false;
        });
      }
      return null;
    }, [notiId]);
 


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
      title: "Flutter Demo App",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
//      routerConfig: appRouter.config(),
      /*
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate, */
    );
  }
}