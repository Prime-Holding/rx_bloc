part of '../router.dart';

@TypedGoRoute<SplashRoute>(path: RoutesPath.splash)
@immutable
class SplashRoute extends GoRouteData implements RouteDataModel {
  const SplashRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SplashPageWithDependencies(
          redirectToLocation: state.uri.queryParameters['from'],
        ),
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
    ),{{#enable_feature_counter}}
    TypedStatefulShellBranch<CounterBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CounterRoute>(path: RoutesPath.counter),
      ],
    ),{{/enable_feature_counter}}{{#enable_feature_widget_toolkit}}
    TypedStatefulShellBranch<WidgetToolkitBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<WidgetToolkitRoute>(path: RoutesPath.widgetToolkit),
      ],
    ),{{/enable_feature_widget_toolkit}}{{#enable_feature_qr_scanner}}
    TypedStatefulShellBranch<QrCodeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<QrCodeRoute>(path: RoutesPath.qrCode),
      ],
    ),{{/enable_feature_qr_scanner}}{{#enable_feature_deeplinks}}
    TypedStatefulShellBranch<DeepLinkBranchData>(
      routes: <TypedRoute<RouteData>>[
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
        ),
      ],
    ),{{/enable_feature_deeplinks}}{{#enable_mfa}}
    TypedStatefulShellBranch<MfaBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<FeatureMfaRoute>(
          path: RoutesPath.mfa,
        ),
      ],
    ),{{/enable_mfa}}
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(
          path: RoutesPath.profile,
          routes: [
            TypedGoRoute<NotificationsRoute>(
              path: RoutesPath.notifications,
            ),{{#enable_pin_code}}
            TypedGoRoute<CreatePinRoute>(
              path: RoutesPath.createPin,
            ),
            TypedGoRoute<UpdatePinRoute>(
              path: RoutesPath.updatePin,
            ),{{/enable_pin_code}}
          ],
        ),
      ],
    ),
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
