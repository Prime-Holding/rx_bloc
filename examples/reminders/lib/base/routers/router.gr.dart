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

import '../../feature_dashboard/views/dashboard_page.dart' as _i3;
import '../../feature_facebook_authentication/views/facebook_login_page.dart'
    as _i1;
import '../../feature_navigation/views/navigation_page.dart' as _i2;
import '../../feature_reminder_list/views/reminder_list_page.dart' as _i4;

class Router extends _i5.RootStackRouter {
  Router([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    FacebookLoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.FacebookLoginPage());
    },
    NavigationRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i2.NavigationPage()));
    },
    DashboardRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i3.DashboardPage()));
    },
    ReminderListRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.WrappedRoute(child: const _i4.ReminderListPage()));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(FacebookLoginRoute.name, path: '/'),
        _i5.RouteConfig(NavigationRoute.name,
            path: '/navigation-page',
            children: [
              _i5.RouteConfig(DashboardRoute.name,
                  path: 'dashboard-page', parent: NavigationRoute.name),
              _i5.RouteConfig(ReminderListRoute.name,
                  path: 'reminder-list-page', parent: NavigationRoute.name)
            ])
      ];
}

/// generated route for
/// [_i1.FacebookLoginPage]
class FacebookLoginRoute extends _i5.PageRouteInfo<void> {
  const FacebookLoginRoute() : super(FacebookLoginRoute.name, path: '/');

  static const String name = 'FacebookLoginRoute';
}

/// generated route for
/// [_i2.NavigationPage]
class NavigationRoute extends _i5.PageRouteInfo<void> {
  const NavigationRoute({List<_i5.PageRouteInfo>? children})
      : super(NavigationRoute.name,
            path: '/navigation-page', initialChildren: children);

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i3.DashboardPage]
class DashboardRoute extends _i5.PageRouteInfo<void> {
  const DashboardRoute() : super(DashboardRoute.name, path: 'dashboard-page');

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i4.ReminderListPage]
class ReminderListRoute extends _i5.PageRouteInfo<void> {
  const ReminderListRoute()
      : super(ReminderListRoute.name, path: 'reminder-list-page');

  static const String name = 'ReminderListRoute';
}
