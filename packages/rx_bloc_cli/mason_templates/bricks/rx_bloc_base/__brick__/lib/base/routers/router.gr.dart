// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../../feature_counter/views/counter_page.dart' as _i1;
import '../../feature_login/views/login_page.dart' as _i2;
import '../../feature_notifications/views/notifications_page.dart' as _i3;

class Router extends _i4.RootStackRouter {
  Router([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    CounterRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(child: const _i1.CounterPage()),
      );
    },
    LoginRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(child: const _i2.LoginPage()),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(child: const _i3.NotificationsPage()),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          CounterRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          LoginRoute.name,
          path: '/login-page',
        ),
        _i4.RouteConfig(
          NotificationsRoute.name,
          path: '/notifications-page',
        ),
      ];
}

/// generated route for
/// [_i1.CounterPage]
class CounterRoute extends _i4.PageRouteInfo<void> {
  const CounterRoute()
      : super(
          CounterRoute.name,
          path: '/',
        );

  static const String name = 'CounterRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i3.NotificationsPage]
class NotificationsRoute extends _i4.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(
          NotificationsRoute.name,
          path: '/notifications-page',
        );

  static const String name = 'NotificationsRoute';
}
