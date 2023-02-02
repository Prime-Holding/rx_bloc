{{> licence.dart }}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../feature_counter/di/counter_page_with_dependencies.dart';
import '../../feature_enter_message/di/enter_message_with_dependencies.dart';
import '../../feature_item_details/di/item_details_with_dependencies.dart';
import '../../feature_items_list/di/items_list_with_dependencies.dart';
import '../../feature_login/di/login_page_with_dependencies.dart';
import '../../feature_notifications/di/notifications_page_with_dependencies.dart';
import '../../feature_splash/di/splash_page_with_dependencies.dart';
import '../common_blocs/coordinator_bloc.dart';
import '../common_services/permissions_service.dart';
import '../models/errors/error_model.dart';
import '../models/item_model.dart';
import 'go_router_refresh_stream.dart';
import 'router_paths.dart';

part 'flows/splash_flow.dart';
part 'router.g.dart';

class AppRouter {
  AppRouter(this._coordinatorBloc) {
    refreshListener = GoRouterRefreshStream(
      _coordinatorBloc.states.isAuthenticated,
    );
  }

  final CoordinatorBlocType _coordinatorBloc;
  late GoRouterRefreshStream refreshListener;

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    initialLocation: const SplashRoute().location,
    routes: $appRoutes,
    redirect: _pageRedirections,
    refreshListenable: GoRouterRefreshStream(
      _coordinatorBloc.states.isAuthenticated,
    ),
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error page!'),
        ),
        body: const Center(
          child: Text('Error message.'),
        ),
      ),
    ),
  );

  FutureOr<String?> _pageRedirections(
      BuildContext context, GoRouterState state) async {
    if (refreshListener.isLoggedIn && state.queryParams['from'] != null) {
      return state.queryParams['from'];
    }
    if (refreshListener.isLoggedIn &&
        state.subloc == const LoginRoute().location) {
      return const CounterRoute().location;
    }

    final pathInfo =
      router.routeInformationParser.matcher.findMatch(state.location);

    final routeName =
      RoutePathsModel.getRouteNameByFullPath(pathInfo.fullpath);

    final hasPermissions = await context
        .read<PermissionsService>()
        .hasPermission(routeName!, graceful: true);

    if (!refreshListener.isLoggedIn && !hasPermissions) {
      return '${const LoginRoute().location}?from=${state.location}';
    }

    if (!hasPermissions) {
      throw AccessDeniedErrorModel();
    }

    return null;
  }
}

abstract class RouteData {
  String get permissionName;
  String get routeLocation;
}

@TypedGoRoute<CounterRoute>(
  path: RouterPaths.counter,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NotificationsRoute>(path: RouterPaths.notifications),
    TypedGoRoute<LoginRoute>(path: RouterPaths.login),
    TypedGoRoute<EnterMessageRoute>(path: RouterPaths.enterMessage),
    TypedGoRoute<ItemsRoute>(
      path: RouterPaths.items,
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ItemDetailsRoute>(path: RouterPaths.itemDetails),
      ],
    ),
  ],
)
@immutable
class CounterRoute extends GoRouteData implements RouteData {
  const CounterRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const CounterPageWithDependencies(),
      );

  @override
  String get permissionName => RoutePathsModel.counter.routeName;

  @override
  String get routeLocation => location;
}

@immutable
class NotificationsRoute extends GoRouteData implements RouteData {
  const NotificationsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const NotificationsPageWithDependencies(),
      );

  @override
  String get permissionName => RoutePathsModel.notifications.routeName;

  @override
  String get routeLocation => location;
}

@immutable
class LoginRoute extends GoRouteData implements RouteData {
  const LoginRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const LoginPageWithDependencies(),
      );

  @override
  String get permissionName => RoutePathsModel.login.routeName;

  @override
  String get routeLocation => location;
}

@immutable
class EnterMessageRoute extends GoRouteData implements RouteData {
  const EnterMessageRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const EnterMessageWithDependencies(),
      );

  @override
  String get permissionName => RoutePathsModel.enterMessage.routeName;

  @override
  String get routeLocation => location;
}

@immutable
class ItemsRoute extends GoRouteData implements RouteData {
  const ItemsRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const ItemsListWithDependencies(),
      );

  @override
  String get permissionName => RoutePathsModel.items.routeName;

  @override
  String get routeLocation => location;
}

@immutable
class ItemDetailsRoute extends GoRouteData implements RouteData {
  const ItemDetailsRoute(this.id);

  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: ItemDetailsWithDependencies(
          itemId: id,
          item: state.extra as ItemModel?,
        ),
      );

  @override
  String get permissionName => RoutePathsModel.itemDetails.routeName;

  @override
  String get routeLocation => location;
}
