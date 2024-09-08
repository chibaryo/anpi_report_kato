import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase_options.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'platform-dependent/fcm/initfcm_android.dart';
import 'platform-dependent/fcm/initfcm_ios.dart';
import 'router/app_router.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  showLocalNotification(message);
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
    const secureStorage = FlutterSecureStorage();
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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      return () {};
    }, const []);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("### message has come ### : ${message.toString()}");
      inspect(message);
      showAndroidLocalNotification(message);
    });

    final appRouter = ref.watch(appRouterProvider);// appRouterProviderは、ルーティングの設定を管理する

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