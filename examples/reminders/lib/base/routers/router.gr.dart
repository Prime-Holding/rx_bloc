// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../../feature_dashboard/views/dashboard_page.dart' as _i2;
import '../../feature_navigation/views/navigation_page.dart' as _i1;
import '../../feature_reminder_list/views/reminder_list_page.dart' as _i3;

class Router extends _i4.RootStackRouter {
  Router([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    NavigationRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.NavigationPage());
    },
    DashboardRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.DashboardPage());
    },
    ReminderListRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.ReminderListPage());
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(NavigationRoute.name, path: '/', children: [
          _i4.RouteConfig(DashboardRoute.name,
              path: 'dashboard-page', parent: NavigationRoute.name),
          _i4.RouteConfig(ReminderListRoute.name,
              path: 'reminder-list-page', parent: NavigationRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.NavigationPage]
class NavigationRoute extends _i4.PageRouteInfo<void> {
  const NavigationRoute({List<_i4.PageRouteInfo>? children})
      : super(NavigationRoute.name, path: '/', initialChildren: children);

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i4.PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: 'dashboard-page');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i3.ReminderListPage]
class ReminderListRoute extends _i4.PageRouteInfo<void> {
  const ReminderListRoute()
      : super(ReminderListRoute.name, path: 'reminder-list-page');

  static const String name = 'ReminderListRoute';
}
