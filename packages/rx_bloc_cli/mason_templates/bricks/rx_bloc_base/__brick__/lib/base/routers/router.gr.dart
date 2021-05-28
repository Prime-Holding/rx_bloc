// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../feature_counter/views/counter_page.dart' as _i3;

class Router extends _i1.RootStackRouter {
  Router([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    CounterPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.CounterPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes =>
      [_i1.RouteConfig(CounterPageRoute.name, path: '/')];
}

class CounterPageRoute extends _i1.PageRouteInfo {
  const CounterPageRoute() : super(name, path: '/');

  static const String name = 'CounterPageRoute';
}
