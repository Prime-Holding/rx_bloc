{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature_counter/views/counter_page.dart';
import '../../feature_login/views/login_page.dart';
import '../../feature_notifications/views/notifications_page.dart';

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
    child: CounterPage.withDependencies(context),
  );
}

@immutable
class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
    MaterialPage(
      key: state.pageKey,
      child: NotificationsPage.withDependencies(context),
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
      child: LoginPage.withDependencies(context),
    );
}
