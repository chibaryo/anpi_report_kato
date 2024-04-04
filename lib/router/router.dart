import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../layouts/commonbase.dart';
import '../providers/firebaseauth/auth_provider.dart';
import '../screens/loginscreen.dart';
import '../screens/protected/homescreen.dart';
import '../screens/protected/postenquete.dart';
import '../screens/protected/settings_screen.dart';
import '../screens/rootscreen.dart';
import '../screens/signupscreen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(firebaseAuthProvider);

  return GoRouter(initialLocation: "/", routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget body) =>
          CommonBaseLayout(body: body),
      routes: <RouteBase>[
        GoRoute(
          path: "/home",
          name: "HomeScreen",
          builder: (BuildContext context, GoRouterState state) =>
              const HomeScreen(),
        ),
        GoRoute(
          path: "/settings",
          name: "SettingsScreen",
          builder: (BuildContext context, GoRouterState state) =>
              const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: "/",
      name: "RootScreen",
      builder: (BuildContext context, GoRouterState state) =>
          const RootScreen(),
    ),
    GoRoute(
      path: "/login",
      name: "LoginScreen",
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: "/signup",
      name: "SignupScreen",
      builder: (BuildContext context, GoRouterState state) =>
          const SignupScreen(),
    ),
    GoRoute(
      path: "/enquete",
      name: "PostEnqueteScreen",
      builder: (BuildContext context, GoRouterState state) =>
          const PostEnqueteScreen(),
    ),
  ],
  redirect: (context, state) {
    final currentUser = authState.currentUser;

    if (currentUser != null && (state.matchedLocation == "/login" || state.matchedLocation == "/")) {
      print("currentUser: $currentUser");
      return "/home";
    }

    return null;
  },
  );
});
