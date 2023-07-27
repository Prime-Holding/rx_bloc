// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    NotificationsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationsPage(),
      );
    },
    GithubRepoListRoute.name: (routeData) {
      final args = routeData.argsAs<GithubRepoListRouteArgs>(
          orElse: () => const GithubRepoListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: GithubRepoListPage(key: args.key)),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    CounterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const CounterPage()),
      );
    },
  };
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [GithubRepoListPage]
class GithubRepoListRoute extends PageRouteInfo<GithubRepoListRouteArgs> {
  GithubRepoListRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          GithubRepoListRoute.name,
          args: GithubRepoListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'GithubRepoListRoute';

  static const PageInfo<GithubRepoListRouteArgs> page =
      PageInfo<GithubRepoListRouteArgs>(name);
}

class GithubRepoListRouteArgs {
  const GithubRepoListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'GithubRepoListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CounterPage]
class CounterRoute extends PageRouteInfo<void> {
  const CounterRoute({List<PageRouteInfo>? children})
      : super(
          CounterRoute.name,
          initialChildren: children,
        );

  static const String name = 'CounterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
