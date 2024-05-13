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
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(
          path: RoutesPath.profile,
          routes: [
            TypedGoRoute<NotificationsRoute>(
              path: RoutesPath.notifications,
            ),
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
