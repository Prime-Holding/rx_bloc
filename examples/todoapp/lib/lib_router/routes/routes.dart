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
    TypedStatefulShellBranch<TodoListBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<TodoListRoute>(
          path: RoutesPath.todoList,
          routes: [
            TypedGoRoute<TodoDetailsRoute>(
              path: RoutesPath.todoDetails,
              routes: [
                TypedGoRoute<TodoUpdateRoute>(
                  path: RoutesPath.todoUpdate,
                )
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<StatsBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<StatsRoute>(path: RoutesPath.stats),
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
class TodoListBranchData extends StatefulShellBranchData {
  const TodoListBranchData();
}

@immutable
class StatsBranchData extends StatefulShellBranchData {
  const StatsBranchData();
}

@immutable
class TodoListRoute extends GoRouteData implements RouteDataModel {
  const TodoListRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const TodoListPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.todoList.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class StatsRoute extends GoRouteData implements RouteDataModel {
  const StatsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const StatisticsPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.stats.permissionName;

  @override
  String get routeLocation => location;
}

@TypedGoRoute<TodoCreateRoute>(path: RoutesPath.todoCreate)
class TodoCreateRoute extends GoRouteData implements RouteDataModel {
  TodoCreateRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        fullscreenDialog: true,
        key: state.pageKey,
        child: TodoManagementPageWithDependencies(
          key: state.pageKey,
        ),
      );

  @override
  String get permissionName => RouteModel.todoCreate.permissionName;

  @override
  String get routeLocation => location;
}

class TodoUpdateRoute extends GoRouteData implements RouteDataModel {
  TodoUpdateRoute(this.id);

  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        fullscreenDialog: true,
        key: state.pageKey,
        child: TodoManagementPageWithDependencies(
          key: state.pageKey,
          id: id,
          initialTodo: state.extra as TodoModel?,
        ),
      );

  @override
  String get permissionName => RouteModel.todoUpdate.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class TodoDetailsRoute extends GoRouteData implements RouteDataModel {
  const TodoDetailsRoute({required this.id});

  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: TodoDetailsPageWithDependencies(
          key: state.pageKey,
          todoModel: state.extra as TodoModel?,
          todoId: id,
        ),
      );

  @override
  String get permissionName => RouteModel.todoDetails.permissionName;

  @override
  String get routeLocation => location;
}
