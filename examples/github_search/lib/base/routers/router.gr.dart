// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/foundation.dart' as _i7;
import 'package:flutter/material.dart' as _i2;

import '../../feature_counter/views/counter_page.dart' as _i3;
import '../../feature_github_repo_list/views/github_repo_list_page.dart' as _i6;
import '../../feature_login/views/login_page.dart' as _i4;
import '../../feature_notifications/views/notifications_page.dart' as _i5;

class Router extends _i1.RootStackRouter {
  Router([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    CounterRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.CounterPage();
        }),
    LoginRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.LoginPage();
        }),
    NotificationsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.NotificationsPage();
        }),
    GithubRepoListRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<GithubRepoListRouteArgs>(
              orElse: () => const GithubRepoListRouteArgs());
          return _i6.GithubRepoListPage(key: args.key);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(CounterRoute.name, path: '/counter-page'),
        _i1.RouteConfig(LoginRoute.name, path: '/login-page'),
        _i1.RouteConfig(NotificationsRoute.name, path: '/notifications-page'),
        _i1.RouteConfig(GithubRepoListRoute.name, path: '/')
      ];
}

class CounterRoute extends _i1.PageRouteInfo {
  const CounterRoute() : super(name, path: '/counter-page');

  static const String name = 'CounterRoute';
}

class LoginRoute extends _i1.PageRouteInfo {
  const LoginRoute() : super(name, path: '/login-page');

  static const String name = 'LoginRoute';
}

class NotificationsRoute extends _i1.PageRouteInfo {
  const NotificationsRoute() : super(name, path: '/notifications-page');

  static const String name = 'NotificationsRoute';
}

class GithubRepoListRoute extends _i1.PageRouteInfo<GithubRepoListRouteArgs> {
  GithubRepoListRoute({_i7.Key? key})
      : super(name, path: '/', args: GithubRepoListRouteArgs(key: key));

  static const String name = 'GithubRepoListRoute';
}

class GithubRepoListRouteArgs {
  const GithubRepoListRouteArgs({this.key});

  final _i7.Key? key;
}
