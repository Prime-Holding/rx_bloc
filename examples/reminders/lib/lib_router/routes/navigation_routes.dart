part of '../router.dart';

@TypedGoRoute<DashboardRoute>(path: RoutesPath.dashboard)
@immutable
class DashboardRoute extends GoRouteData implements RouteData {
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

@TypedGoRoute<RemindersRoute>(path: RoutesPath.reminders)
@immutable
class RemindersRoute extends GoRouteData implements RouteData {
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
