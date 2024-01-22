// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../base/common_blocs/coordinator_bloc.dart';
import '../feature_dashboard/di/dashboard_page_with_dependencies.dart';
import '../feature_facebook_authentication/views/facebook_login_page.dart';
import '../feature_navigation/views/navigation_page.dart';
import '../feature_reminder_list/di/reminder_list_page_with_dependencies.dart';
import '../feature_splash/di/splash_page_with_dependencies.dart';
import 'models/route_data_model.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart';
part 'routes/navigation_routes.dart';
part 'routes/root/login_routes.dart';
part 'routes/root/splash_routes.dart';

/// The app's main router used to navigate between pages
class AppRouter {
  AppRouter(
    this.coordinatorBloc,
    this.rootNavigatorKey,
    this.shellNavigatorKey,
  );

  final CoordinatorBlocType coordinatorBloc;
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> shellNavigatorKey;

  late final _GoRouterRefreshStream _refreshListener =
      _GoRouterRefreshStream(coordinatorBloc.states.isAuthenticated);

  /// Exposes the [GoRouter] instance used for the app's main navigation
  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const SplashRoute().location,
    redirect: _pageRedirections,
    refreshListenable: _refreshListener,
    routes: [
      $splashRoute,
      $loginRoute,
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => NavigationPage(
          child: child,
        ),
        routes: [
          $dashboardRoute,
          $remindersRoute,
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(
        error: state.error,
      ),
    ),
  );

  FutureOr<String?> _pageRedirections(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (_refreshListener.isLoggedIn &&
        state.uri.queryParameters['from'] != null) {
      return state.uri.queryParameters['from'];
    }
    if (_refreshListener.isLoggedIn &&
        state.matchedLocation == RoutesPath.login) {
      return RoutesPath.dashboard;
    }

    if (state.matchedLocation == RoutesPath.splash) {
      return null;
    }

    if (!_refreshListener.isLoggedIn &&
        state.matchedLocation != RoutesPath.login) {
      return '${const LoginRoute().location}?from=${state.uri.toString()}';
    }

    return null;
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<bool> stream) {
    _subscription = stream.listen(
      (bool isLoggedIn) {
        this.isLoggedIn = isLoggedIn;
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<bool> _subscription;
  late bool isLoggedIn = false;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Contract containing data about a app navigation route
abstract class RouteData {
  String get routeLocation;
}
