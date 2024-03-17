import 'dart:developer';

import 'package:anpi_report_ios/firebase_options.dart';
import 'package:anpi_report_ios/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/thememode/themeswitcher_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Settings.init(cacheProvider: SharePreferenceCache());
//  await initializeFlutterLocalNotificationsPlugin();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyDarkMode = ref.watch(themeSwitcherDataProvider);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("### message has come ### : $message");
      inspect(message);
//      showNotification(message);
    });

    useEffect((){
      return () {};
    }, const []);

    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      title: "Flutter Demo App",
      theme: keyDarkMode
      ?
      ThemeData.light().copyWith(     
        primaryColor: Colors.teal,
        secondaryHeaderColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
      )
      :
      ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        secondaryHeaderColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF170635),
        canvasColor: const Color(0xFF170635),
//        primarySwatch: Colors.purple,
      )
      ,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
