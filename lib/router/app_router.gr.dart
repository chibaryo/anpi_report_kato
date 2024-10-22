// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AppHomeRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppHomeRouterScreen(),
      );
    },
    AppHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppHomeScreen(),
      );
    },
    EditReportRoute.name: (routeData) {
      final args = routeData.argsAs<EditReportRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditReportScreen(
          key: args.key,
          notificationId: args.notificationId,
        ),
      );
    },
    NotiAdminDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<NotiAdminDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotiAdminDetailsScreen(
          key: args.key,
          notiId: args.notiId,
        ),
      );
    },
    NotiAdminRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotiAdminRouterScreen(),
      );
    },
    NotiAdminRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotiAdminScreen(),
      );
    },
    PostEnqueteRoute.name: (routeData) {
      final args = routeData.argsAs<PostEnqueteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PostEnqueteScreen(
          key: args.key,
          notificationId: args.notificationId,
        ),
      );
    },
    PrivacyPolicyWebViewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrivacyPolicyWebViewScreen(),
      );
    },
    RootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RootScreen(),
      );
    },
    SettingsRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsRouterScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsScreen(),
      );
    },
    SigninRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SigninScreen(),
      );
    },
    SignupRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignupScreen(),
      );
    },
    TabsRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabsRouterScreen(),
      );
    },
    TemplateAdminRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TemplateAdminScreen(),
      );
    },
    TermsWebViewRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TermsWebViewScreen(),
      );
    },
    TheOtherOpsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TheOtherOpsScreen(),
      );
    },
    TopicSelectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TopicSelectScreen(),
      );
    },
    UserAdminRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UserAdminScreen(),
      );
    },
  };
}

/// generated route for
/// [AppHomeRouterScreen]
class AppHomeRouterRoute extends PageRouteInfo<void> {
  const AppHomeRouterRoute({List<PageRouteInfo>? children})
      : super(
          AppHomeRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppHomeRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppHomeScreen]
class AppHomeRoute extends PageRouteInfo<void> {
  const AppHomeRoute({List<PageRouteInfo>? children})
      : super(
          AppHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditReportScreen]
class EditReportRoute extends PageRouteInfo<EditReportRouteArgs> {
  EditReportRoute({
    Key? key,
    required String notificationId,
    List<PageRouteInfo>? children,
  }) : super(
          EditReportRoute.name,
          args: EditReportRouteArgs(
            key: key,
            notificationId: notificationId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditReportRoute';

  static const PageInfo<EditReportRouteArgs> page =
      PageInfo<EditReportRouteArgs>(name);
}

class EditReportRouteArgs {
  const EditReportRouteArgs({
    this.key,
    required this.notificationId,
  });

  final Key? key;

  final String notificationId;

  @override
  String toString() {
    return 'EditReportRouteArgs{key: $key, notificationId: $notificationId}';
  }
}

/// generated route for
/// [NotiAdminDetailsScreen]
class NotiAdminDetailsRoute extends PageRouteInfo<NotiAdminDetailsRouteArgs> {
  NotiAdminDetailsRoute({
    Key? key,
    required String notiId,
    List<PageRouteInfo>? children,
  }) : super(
          NotiAdminDetailsRoute.name,
          args: NotiAdminDetailsRouteArgs(
            key: key,
            notiId: notiId,
          ),
          initialChildren: children,
        );

  static const String name = 'NotiAdminDetailsRoute';

  static const PageInfo<NotiAdminDetailsRouteArgs> page =
      PageInfo<NotiAdminDetailsRouteArgs>(name);
}

class NotiAdminDetailsRouteArgs {
  const NotiAdminDetailsRouteArgs({
    this.key,
    required this.notiId,
  });

  final Key? key;

  final String notiId;

  @override
  String toString() {
    return 'NotiAdminDetailsRouteArgs{key: $key, notiId: $notiId}';
  }
}

/// generated route for
/// [NotiAdminRouterScreen]
class NotiAdminRouterRoute extends PageRouteInfo<void> {
  const NotiAdminRouterRoute({List<PageRouteInfo>? children})
      : super(
          NotiAdminRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotiAdminRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NotiAdminScreen]
class NotiAdminRoute extends PageRouteInfo<void> {
  const NotiAdminRoute({List<PageRouteInfo>? children})
      : super(
          NotiAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotiAdminRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PostEnqueteScreen]
class PostEnqueteRoute extends PageRouteInfo<PostEnqueteRouteArgs> {
  PostEnqueteRoute({
    Key? key,
    required String notificationId,
    List<PageRouteInfo>? children,
  }) : super(
          PostEnqueteRoute.name,
          args: PostEnqueteRouteArgs(
            key: key,
            notificationId: notificationId,
          ),
          initialChildren: children,
        );

  static const String name = 'PostEnqueteRoute';

  static const PageInfo<PostEnqueteRouteArgs> page =
      PageInfo<PostEnqueteRouteArgs>(name);
}

class PostEnqueteRouteArgs {
  const PostEnqueteRouteArgs({
    this.key,
    required this.notificationId,
  });

  final Key? key;

  final String notificationId;

  @override
  String toString() {
    return 'PostEnqueteRouteArgs{key: $key, notificationId: $notificationId}';
  }
}

/// generated route for
/// [PrivacyPolicyWebViewScreen]
class PrivacyPolicyWebViewRoute extends PageRouteInfo<void> {
  const PrivacyPolicyWebViewRoute({List<PageRouteInfo>? children})
      : super(
          PrivacyPolicyWebViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyWebViewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RootScreen]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsRouterScreen]
class SettingsRouterRoute extends PageRouteInfo<void> {
  const SettingsRouterRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SigninScreen]
class SigninRoute extends PageRouteInfo<void> {
  const SigninRoute({List<PageRouteInfo>? children})
      : super(
          SigninRoute.name,
          initialChildren: children,
        );

  static const String name = 'SigninRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabsRouterScreen]
class TabsRouterRoute extends PageRouteInfo<void> {
  const TabsRouterRoute({List<PageRouteInfo>? children})
      : super(
          TabsRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabsRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TemplateAdminScreen]
class TemplateAdminRoute extends PageRouteInfo<void> {
  const TemplateAdminRoute({List<PageRouteInfo>? children})
      : super(
          TemplateAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'TemplateAdminRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TermsWebViewScreen]
class TermsWebViewRoute extends PageRouteInfo<void> {
  const TermsWebViewRoute({List<PageRouteInfo>? children})
      : super(
          TermsWebViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsWebViewRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TheOtherOpsScreen]
class TheOtherOpsRoute extends PageRouteInfo<void> {
  const TheOtherOpsRoute({List<PageRouteInfo>? children})
      : super(
          TheOtherOpsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TheOtherOpsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TopicSelectScreen]
class TopicSelectRoute extends PageRouteInfo<void> {
  const TopicSelectRoute({List<PageRouteInfo>? children})
      : super(
          TopicSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'TopicSelectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserAdminScreen]
class UserAdminRoute extends PageRouteInfo<void> {
  const UserAdminRoute({List<PageRouteInfo>? children})
      : super(
          UserAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserAdminRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
