// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../feature_counter/views/counter_page.dart' as _i3;
import '../../feature_login/views/login_page.dart' as _i4;
import '../../feature_notifications/views/notifications_page.dart' as _i5;

class Router extends _i1.RootStackRouter {
  Router([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    CounterRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.CounterPage());
    },
    LoginRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.LoginPage());
    },
    NotificationsRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.NotificationsPage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(CounterRoute.name, path: '/'),
        _i1.RouteConfig(LoginRoute.name, path: '/login-page'),
        _i1.RouteConfig(NotificationsRoute.name, path: '/notifications-page')
      ];
}

class CounterRoute extends _i1.PageRouteInfo<void> {
  const CounterRoute() : super(name, path: '/');

  static const String name = 'CounterRoute';
}

class LoginRoute extends _i1.PageRouteInfo<void> {
  const LoginRoute() : super(name, path: '/login-page');

  static const String name = 'LoginRoute';
}

class NotificationsRoute extends _i1.PageRouteInfo<void> {
  const NotificationsRoute() : super(name, path: '/notifications-page');

  static const String name = 'NotificationsRoute';
}
