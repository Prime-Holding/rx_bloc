part of '../router.dart';

/// Route used for navigating to the dashboard page
@TypedGoRoute<DashboardRoute>(path: RoutesPath.dashboard)
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
  String get routeLocation => location;
}

/// Route used for navigating to the page containing a list of reminders
@TypedGoRoute<RemindersRoute>(path: RoutesPath.reminders)
@immutable
class RemindersRoute extends GoRouteData implements RouteDataModel {
  const RemindersRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const ReminderListPageWithDependencies(),
      );

  @override
  String get routeLocation => location;
}
