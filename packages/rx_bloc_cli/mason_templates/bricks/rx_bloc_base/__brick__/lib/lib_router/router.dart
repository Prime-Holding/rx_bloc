{{> licence.dart }}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../base/common_blocs/coordinator_bloc.dart';
import '../base/models/item_model.dart';
import '../feature_counter/di/counter_page_with_dependencies.dart';
import '../feature_enter_message/di/enter_message_with_dependencies.dart';
import '../feature_item_details/di/item_details_with_dependencies.dart';
import '../feature_items_list/di/items_list_with_dependencies.dart';
import '../feature_login/di/login_page_with_dependencies.dart';
import '../feature_notifications/di/notifications_page_with_dependencies.dart';
import '../feature_splash/di/splash_page_with_dependencies.dart';
import '../feature_splash/services/splash_service.dart';
import '../lib_permissions/services/permissions_service.dart';
import 'models/route_model.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart';
part 'routes/enter_message_routes.dart';
part 'routes/item_routes.dart';
part 'routes/notification_routes.dart';
part 'routes/onboarding_routes.dart';
part 'routes/root/counter_routes.dart';
part 'routes/root/splash_routes.dart';

class AppRouter {
  AppRouter(this._coordinatorBloc);

  final CoordinatorBlocType _coordinatorBloc;

  late final _GoRouterRefreshStream _refreshListener =
      _GoRouterRefreshStream(_coordinatorBloc.states.isAuthenticated);

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
    redirect: _pageRedirections,
    refreshListenable: _refreshListener,
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const ErrorPage(),
    ),
  );

  FutureOr<String?> _pageRedirections(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (_refreshListener.isLoggedIn && state.queryParams['from'] != null) {
      return state.queryParams['from'];
    }
    if (_refreshListener.isLoggedIn &&
        state.subloc == const LoginRoute().location) {
      return const CounterRoute().location;
    }

    if (state.subloc != const SplashRoute().location) {
      if (!context.read<SplashService>().isAppInitialized) {
        return '${const SplashRoute().location}?from=${state.location}';
      }
    }

    final pathInfo =
        router.routeInformationParser.matcher.findMatch(state.location);

    final routeName = RouteModel.getRouteNameByFullPath(pathInfo.fullpath);

    final hasPermissions = routeName != null
        ? await context
            .read<PermissionsService>()
            .hasPermission(routeName, graceful: true)
        : true;

    if (!_refreshListener.isLoggedIn && !hasPermissions) {
      return '${const LoginRoute().location}?from=${state.location}';
    }

    if (!hasPermissions) {
      return const NotificationsRoute().location;
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

abstract class RouteData {
  String get permissionName;
  String get routeLocation;
}
