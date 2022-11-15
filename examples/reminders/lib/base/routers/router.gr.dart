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
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../feature_dashboard/views/dashboard_page.dart' as _i4;
import '../../feature_facebook_authentication/views/facebook_login_page.dart'
    as _i2;
import '../../feature_navigation/views/navigation_page.dart' as _i3;
import '../../feature_reminder_list/views/reminder_list_page.dart' as _i5;
import '../../feature_splash/splash_page.dart' as _i1;

class Router extends _i6.RootStackRouter {
  Router([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    FacebookLoginRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.FacebookLoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i3.NavigationPage()),
      );
    },
    DashboardRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardRouteArgs>(
          orElse: () => const DashboardRouteArgs());
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: _i4.DashboardPage(key: args.key)),
      );
    },
    ReminderListRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i5.ReminderListPage()),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          FacebookLoginRoute.name,
          path: '/facebook-login-page',
        ),
        _i6.RouteConfig(
          NavigationRoute.name,
          path: '/navigation-page',
          children: [
            _i6.RouteConfig(
              DashboardRoute.name,
              path: 'dashboard-page',
              parent: NavigationRoute.name,
            ),
            _i6.RouteConfig(
              ReminderListRoute.name,
              path: 'reminder-list-page',
              parent: NavigationRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.FacebookLoginPage]
class FacebookLoginRoute extends _i6.PageRouteInfo<void> {
  const FacebookLoginRoute()
      : super(
          FacebookLoginRoute.name,
          path: '/facebook-login-page',
        );

  static const String name = 'FacebookLoginRoute';
}

/// generated route for
/// [_i3.NavigationPage]
class NavigationRoute extends _i6.PageRouteInfo<void> {
  const NavigationRoute({List<_i6.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          path: '/navigation-page',
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i4.DashboardPage]
class DashboardRoute extends _i6.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({_i7.Key? key})
      : super(
          DashboardRoute.name,
          path: 'dashboard-page',
          args: DashboardRouteArgs(key: key),
        );

  static const String name = 'DashboardRoute';
}

class DashboardRouteArgs {
  const DashboardRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ReminderListPage]
class ReminderListRoute extends _i6.PageRouteInfo<void> {
  const ReminderListRoute()
      : super(
          ReminderListRoute.name,
          path: 'reminder-list-page',
        );

  static const String name = 'ReminderListRoute';
}
