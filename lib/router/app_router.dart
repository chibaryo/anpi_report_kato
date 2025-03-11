import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../screens/authenticated/aboutthisapp_screen.dart';
import '../screens/authenticated/admins/notiadmin_screen.dart';
import '../screens/authenticated/admins/notiadmindetails_screen.dart';
import '../screens/authenticated/admins/playadmin_screen.dart';
import '../screens/authenticated/admins/templateadmin_screen.dart';
import '../screens/authenticated/admins/theotherops_screen.dart';
import '../screens/authenticated/admins/useradmin_screen.dart';
import '../screens/authenticated/apphome_screen.dart';
import '../screens/authenticated/appversionhistory_screen.dart';
import '../screens/authenticated/editreport_screen.dart';
import '../screens/authenticated/postenquete_screen.dart';
import '../screens/authenticated/privacypolicy_screen.dart';
import '../screens/authenticated/settings_screen.dart';
import '../screens/authenticated/terms_screen.dart';
import '../screens/authenticated/topicselect_screen.dart';
import '../screens/unauthenticated/scanqr_screen.dart';
import '../screens/unauthenticated/tabsrouter_screen.dart';
import '../screens/unauthenticated/signin_screen.dart';
import '../screens/unauthenticated/signup_screen.dart';
import '../screens/unauthenticated/root_screen.dart';
import 'guard/authguard.dart';
import 'guard/noauthguard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino, .adaptive ..etc


  @override
  List<AutoRoute> get routes => [
/*    AutoRoute(
      page: RootRoute.page,
      path: '/',
      //guards: [NoAuthGuard(ref: ref)],
    ), */
    AutoRoute(
      page: SigninRoute.page,
      path: '/signin',
      guards: [NoAuthGuard()],
      initial: true,
    ),
    AutoRoute(
      page: SignupRoute.page,
      path: '/signup',
    ),
    AutoRoute(
      page: ScanQRRoute.page,
    ),
    AutoRoute(
      page: TabsRouterRoute.page,
      guards: [AuthGuard()],
      children: [
        AutoRoute(
          page: AppHomeRouterRoute.page,
//          path: 'apphome',
          children: [
            AutoRoute(
              page: AppHomeRoute.page,
              //path: 'apphome',
              initial: true,
            ),
            AutoRoute(
              page: PostEnqueteRoute.page,
              guards: [AuthGuard()],
              //path: 'postenquete/:notificationId',
            ),
            AutoRoute(
              page: EditReportRoute.page,
              //path: 'postenquete/:notificationId',
            ),
          ]
        ),
        AutoRoute(
          page: SettingsRouterRoute.page,
          //guards: [AuthGuard(ref: ref)],
          children: [
            AutoRoute(
              page: SettingsRoute.page,
              //path: 'settings',
              initial: true,
              // guards: [AuthGuard(ref: ref)]
            ),
            AutoRoute(
              page: NotiAdminRouterRoute.page,
              children: [
                AutoRoute(
                  page: NotiAdminRoute.page,
                  initial: true
                ),
                AutoRoute(
                  page: NotiAdminDetailsRoute.page,
                ),
              ],
            ),
            AutoRoute(
              page: UserAdminRoute.page,
            ),
            AutoRoute(
              page: PlayAdminRoute.page,
            ),
            AutoRoute(
              page: TemplateAdminRoute.page,
            ),
            AutoRoute(
              page: TopicSelectRoute.page,
            ),
            AutoRoute(
              page: TheOtherOpsRoute.page,
            ),
            AutoRoute(
              page: TermsWebViewRoute.page,
            ),
            AutoRoute(
              page: PrivacyPolicyWebViewRoute.page,
            ),
            AutoRoute(
              page: AboutThisAppRouterRoute.page,
              children: [
                AutoRoute(
                  page: AboutThisAppRoute.page,
                  initial: true,
                ),
                AutoRoute(
                  page: AppVersionHistroyRoute.page,
                )
              ]
            ),
          ]
        ),
      ],
//      guards: [AuthGuard(ref: ref)],
    ),
  ];
}
