// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../feature_counter/views/counter_page.dart' as _i4;
import '../../feature_notifications/views/login_page.dart' as _i3;

class Router extends _i1.RootStackRouter {
  Router([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.LoginPage();
        }),
    CounterPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.CounterPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
    _i1.RouteConfig(LoginPageRoute.name, path: '/'),
    _i1.RouteConfig(CounterPageRoute.name, path: '/counter-page')
  ];
}

class LoginPageRoute extends _i1.PageRouteInfo {
  const LoginPageRoute() : super(name, path: '/');

  static const String name = 'LoginPageRoute';
}

class CounterPageRoute extends _i1.PageRouteInfo {
  const CounterPageRoute() : super(name, path: '/counter-page');

  static const String name = 'CounterPageRoute';
}
