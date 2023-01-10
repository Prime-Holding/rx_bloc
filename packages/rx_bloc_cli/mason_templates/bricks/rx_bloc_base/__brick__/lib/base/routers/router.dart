{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature_counter/di/counter_page_with_dependencies.dart';
import '../../feature_login/di/login_page_with_dependencies.dart';
import '../../feature_notifications/di/notifications_page_with_dependencies.dart';

part 'router.g.dart';

@TypedGoRoute<CounterRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NotificationsRoute>(path: 'notifications')
  ],
)
@immutable
class CounterRoute extends GoRouteData {
  const CounterRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
  MaterialPage(
    key: state.pageKey,
    child: const CounterPageWithDependencies(),
  );
}

@immutable
class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
      key: state.pageKey,
      child: const NotificationsPageWithDependencies(),
    );
}

@TypedGoRoute<LoginRoute>(path: '/login')
@immutable
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
      key: state.pageKey,
      child: const LoginPageWithDependencies(),
    );
}
