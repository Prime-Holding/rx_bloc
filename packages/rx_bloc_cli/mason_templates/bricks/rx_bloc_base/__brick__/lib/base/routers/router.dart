{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../feature_counter/di/counter_page_with_dependencies.dart';
import '../../feature_login/di/login_page_with_dependencies.dart';
import '../../feature_notifications/di/notifications_page_with_dependencies.dart';
import '../common_blocs/coordinator_bloc.dart';
import 'go_router_refresh_stream.dart';

part 'router.g.dart';

class AppRouter {
  AppRouter(this._context) {
    refreshListener =
      GoRouterRefreshStream(_context.read<CoordinatorBlocType>().states.isAuthenticated);
  }

  final BuildContext _context;
  late GoRouterRefreshStream refreshListener;

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
      routes: $appRoutes,
      redirect: (context, state) {
        if (refreshListener.isLoggedIn && state.location == '/login') {
          return '/';
        }
        return null;
      },
      refreshListenable:
        GoRouterRefreshStream(_context.read<CoordinatorBlocType>().states.isAuthenticated),
    );
}

abstract class RouteData {
  String get permissionName;
  String get routeLocation;
}

class Permissions {
  static String counterPage = 'CounterRoute';
  static String notificationsPage = 'NotificationsRoute';
  static String loginPage = 'LoginRoute';
}

@TypedGoRoute<CounterRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NotificationsRoute>(path: 'notifications'),
    TypedGoRoute<LoginRoute>(path: 'login')
  ],
)
@immutable
class CounterRoute extends GoRouteData implements RouteData {
  const CounterRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
  MaterialPage(
    key: state.pageKey,
    child: const CounterPageWithDependencies(),
  );

  @override
  String get permissionName => Permissions.counterPage;

  @override
  String get routeLocation => location;
}

@immutable
class NotificationsRoute extends GoRouteData implements RouteData {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
      key: state.pageKey,
      child: const NotificationsPageWithDependencies(),
    );

  @override
  String get permissionName => Permissions.notificationsPage;

  @override
  String get routeLocation => location;
}

@immutable
class LoginRoute extends GoRouteData implements RouteData {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
      key: state.pageKey,
      child: const LoginPageWithDependencies(),
    );

  @override
  String get permissionName => Permissions.loginPage;

  @override
  String get routeLocation => location;
}
