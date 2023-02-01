part of '../router.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
@immutable
class SplashRoute extends GoRouteData implements RouteData {
  const SplashRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const SplashPageWithDependencies(),
      );

  @override
  String get permissionName => PermissionNames.splashPage;

  @override
  String get routeLocation => location;
}
