// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutThisAppScreen]
class AboutThisAppRoute extends PageRouteInfo<void> {
  const AboutThisAppRoute({List<PageRouteInfo>? children})
    : super(AboutThisAppRoute.name, initialChildren: children);

  static const String name = 'AboutThisAppRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutThisAppScreen();
    },
  );
}

/// generated route for
/// [AppHomeRouterScreen]
class AppHomeRouterRoute extends PageRouteInfo<void> {
  const AppHomeRouterRoute({List<PageRouteInfo>? children})
    : super(AppHomeRouterRoute.name, initialChildren: children);

  static const String name = 'AppHomeRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppHomeRouterScreen();
    },
  );
}

/// generated route for
/// [AppHomeScreen]
class AppHomeRoute extends PageRouteInfo<void> {
  const AppHomeRoute({List<PageRouteInfo>? children})
    : super(AppHomeRoute.name, initialChildren: children);

  static const String name = 'AppHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppHomeScreen();
    },
  );
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
         args: EditReportRouteArgs(key: key, notificationId: notificationId),
         initialChildren: children,
       );

  static const String name = 'EditReportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditReportRouteArgs>();
      return EditReportScreen(
        key: args.key,
        notificationId: args.notificationId,
      );
    },
  );
}

class EditReportRouteArgs {
  const EditReportRouteArgs({this.key, required this.notificationId});

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
         args: NotiAdminDetailsRouteArgs(key: key, notiId: notiId),
         initialChildren: children,
       );

  static const String name = 'NotiAdminDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotiAdminDetailsRouteArgs>();
      return NotiAdminDetailsScreen(key: args.key, notiId: args.notiId);
    },
  );
}

class NotiAdminDetailsRouteArgs {
  const NotiAdminDetailsRouteArgs({this.key, required this.notiId});

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
    : super(NotiAdminRouterRoute.name, initialChildren: children);

  static const String name = 'NotiAdminRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotiAdminRouterScreen();
    },
  );
}

/// generated route for
/// [NotiAdminScreen]
class NotiAdminRoute extends PageRouteInfo<void> {
  const NotiAdminRoute({List<PageRouteInfo>? children})
    : super(NotiAdminRoute.name, initialChildren: children);

  static const String name = 'NotiAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotiAdminScreen();
    },
  );
}

/// generated route for
/// [PlayAdminScreen]
class PlayAdminRoute extends PageRouteInfo<void> {
  const PlayAdminRoute({List<PageRouteInfo>? children})
    : super(PlayAdminRoute.name, initialChildren: children);

  static const String name = 'PlayAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlayAdminScreen();
    },
  );
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
         args: PostEnqueteRouteArgs(key: key, notificationId: notificationId),
         initialChildren: children,
       );

  static const String name = 'PostEnqueteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PostEnqueteRouteArgs>();
      return PostEnqueteScreen(
        key: args.key,
        notificationId: args.notificationId,
      );
    },
  );
}

class PostEnqueteRouteArgs {
  const PostEnqueteRouteArgs({this.key, required this.notificationId});

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
    : super(PrivacyPolicyWebViewRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyWebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyWebViewScreen();
    },
  );
}

/// generated route for
/// [RootScreen]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RootScreen();
    },
  );
}

/// generated route for
/// [ScanQRScreen]
class ScanQRRoute extends PageRouteInfo<void> {
  const ScanQRRoute({List<PageRouteInfo>? children})
    : super(ScanQRRoute.name, initialChildren: children);

  static const String name = 'ScanQRRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScanQRScreen();
    },
  );
}

/// generated route for
/// [SettingsRouterScreen]
class SettingsRouterRoute extends PageRouteInfo<void> {
  const SettingsRouterRoute({List<PageRouteInfo>? children})
    : super(SettingsRouterRoute.name, initialChildren: children);

  static const String name = 'SettingsRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsRouterScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [SigninScreen]
class SigninRoute extends PageRouteInfo<void> {
  const SigninRoute({List<PageRouteInfo>? children})
    : super(SigninRoute.name, initialChildren: children);

  static const String name = 'SigninRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SigninScreen();
    },
  );
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupScreen();
    },
  );
}

/// generated route for
/// [TabsRouterScreen]
class TabsRouterRoute extends PageRouteInfo<void> {
  const TabsRouterRoute({List<PageRouteInfo>? children})
    : super(TabsRouterRoute.name, initialChildren: children);

  static const String name = 'TabsRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TabsRouterScreen();
    },
  );
}

/// generated route for
/// [TemplateAdminScreen]
class TemplateAdminRoute extends PageRouteInfo<void> {
  const TemplateAdminRoute({List<PageRouteInfo>? children})
    : super(TemplateAdminRoute.name, initialChildren: children);

  static const String name = 'TemplateAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TemplateAdminScreen();
    },
  );
}

/// generated route for
/// [TermsWebViewScreen]
class TermsWebViewRoute extends PageRouteInfo<void> {
  const TermsWebViewRoute({List<PageRouteInfo>? children})
    : super(TermsWebViewRoute.name, initialChildren: children);

  static const String name = 'TermsWebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermsWebViewScreen();
    },
  );
}

/// generated route for
/// [TheOtherOpsScreen]
class TheOtherOpsRoute extends PageRouteInfo<void> {
  const TheOtherOpsRoute({List<PageRouteInfo>? children})
    : super(TheOtherOpsRoute.name, initialChildren: children);

  static const String name = 'TheOtherOpsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TheOtherOpsScreen();
    },
  );
}

/// generated route for
/// [TopicSelectScreen]
class TopicSelectRoute extends PageRouteInfo<void> {
  const TopicSelectRoute({List<PageRouteInfo>? children})
    : super(TopicSelectRoute.name, initialChildren: children);

  static const String name = 'TopicSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TopicSelectScreen();
    },
  );
}

/// generated route for
/// [UserAdminScreen]
class UserAdminRoute extends PageRouteInfo<void> {
  const UserAdminRoute({List<PageRouteInfo>? children})
    : super(UserAdminRoute.name, initialChildren: children);

  static const String name = 'UserAdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserAdminScreen();
    },
  );
}
