// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../feature_counter/views/counter_page.dart' as _i1;
import '../../feature_github_repo_list/views/github_repo_list_page.dart' as _i4;
import '../../feature_login/views/login_page.dart' as _i2;
import '../../feature_notifications/views/notifications_page.dart' as _i3;

class Router extends _i5.RootStackRouter {
  Router([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    CounterRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i1.CounterPage()));
    },
    LoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i2.LoginPage()));
    },
    NotificationsRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i3.NotificationsPage()));
    },
    GithubRepoListRoute.name: (routeData) {
      final args = routeData.argsAs<GithubRepoListRouteArgs>(
          orElse: () => const GithubRepoListRouteArgs());
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i5.WrappedRoute(child: _i4.GithubRepoListPage(key: args.key)));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(CounterRoute.name, path: '/counter-page'),
        _i5.RouteConfig(LoginRoute.name, path: '/login-page'),
        _i5.RouteConfig(NotificationsRoute.name, path: '/notifications-page'),
        _i5.RouteConfig(GithubRepoListRoute.name, path: '/')
      ];
}

/// generated route for
/// [_i1.CounterPage]
class CounterRoute extends _i5.PageRouteInfo<void> {
  const CounterRoute() : super(CounterRoute.name, path: '/counter-page');

  static const String name = 'CounterRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login-page');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.NotificationsPage]
class NotificationsRoute extends _i5.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(NotificationsRoute.name, path: '/notifications-page');

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i4.GithubRepoListPage]
class GithubRepoListRoute extends _i5.PageRouteInfo<GithubRepoListRouteArgs> {
  GithubRepoListRoute({_i6.Key? key})
      : super(GithubRepoListRoute.name,
            path: '/', args: GithubRepoListRouteArgs(key: key));

  static const String name = 'GithubRepoListRoute';
}

class GithubRepoListRouteArgs {
  const GithubRepoListRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'GithubRepoListRouteArgs{key: $key}';
  }
}
