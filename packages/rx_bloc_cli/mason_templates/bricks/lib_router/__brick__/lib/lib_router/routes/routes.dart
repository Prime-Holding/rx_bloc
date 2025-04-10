part of '../router.dart';

@TypedGoRoute<SplashRoute>(path: RoutesPath.splash)
@immutable
class SplashRoute extends GoRouteData implements RouteDataModel {
  const SplashRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SplashPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.splash.permissionName;

  @override
  String get routeLocation => location;
}

@TypedStatefulShellRoute<HomeStatefulShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<DashboardBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DashboardRoute>(path: RoutesPath.dashboard),
      ],
    ), {{#has_showcase}}
        TypedStatefulShellBranch<ShowcaseBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ShowcaseRoute>(
          path: RoutesPath.showcase,
          routes: [ {{#enable_feature_counter}}
            /// Counter route
            TypedGoRoute<CounterRoute>(
              path: RoutesPath.counter,
            ),{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
            /// Widget toolkit route
            TypedGoRoute<WidgetToolkitRoute>(
              path: RoutesPath.widgetToolkit,
            ),{{/enable_feature_widget_toolkit}}{{#enable_feature_qr_scanner}}
            /// QR code route
            TypedGoRoute<QrCodeRoute>(
              path: RoutesPath.qrCode,
            ),{{/enable_feature_qr_scanner}}{{#enable_feature_deeplinks}}
            /// Deeplink routes
            TypedGoRoute<DeepLinksRoute>(
              path: RoutesPath.deepLinks,
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<DeepLinkDetailsRoute>(
                  path: RoutesPath.deepLinkDetails,
                ),
                TypedGoRoute<EnterMessageRoute>(
                  path: RoutesPath.enterMessage,
                ),
              ],
            ),{{/enable_feature_deeplinks}}{{#enable_mfa}}
            /// MFA routes
            TypedGoRoute<FeatureMfaRoute>(
              path: RoutesPath.mfa,
            ),{{/enable_mfa}}{{#enable_feature_otp}}
            /// OTP route
            TypedGoRoute<FeatureOtpRoute>(
              path: RoutesPath.showcaseOtp,
            ),{{/enable_feature_otp}}
            TypedGoRoute<NotificationsRoute>(
              path: RoutesPath.notifications,
            ),
          ],
        ),
      ],
    ),{{/has_showcase}}

    {{#enable_profile}}
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(
          path: RoutesPath.profile,
        ),
      ],
    ),{{/enable_profile}}
  ],
)
@immutable
class HomeStatefulShellRoute extends StatefulShellRouteData {
  const HomeStatefulShellRoute();

  @override
  Page<void> pageBuilder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) =>
      MaterialPage(
        key: state.pageKey,
        child: navigationShell,
      );

  static Widget $navigatorContainerBuilder(BuildContext context,
      StatefulNavigationShell navigationShell, List<Widget> children) =>
      HomePage(
        currentIndex: navigationShell.currentIndex,
        branchNavigators: children,
        onNavigationItemSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      );
}

@immutable
class DashboardBranchData extends StatefulShellBranchData {
  const DashboardBranchData();
}

@immutable
class DashboardRoute extends GoRouteData implements RouteDataModel {
  const DashboardRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const DashboardPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.dashboard.permissionName;

  @override
  String get routeLocation => location;
}

{{^enable_profile}}
@immutable
@TypedGoRoute<NotificationsRoute>(path: RoutesPath.notifications)
class NotificationsRoute extends GoRouteData implements RouteDataModel {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const NotificationsPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.notifications.permissionName;

  @override
  String get routeLocation => location;
}
{{/enable_profile}}
