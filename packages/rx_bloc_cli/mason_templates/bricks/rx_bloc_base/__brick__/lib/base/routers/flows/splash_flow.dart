part of '../router.dart';

@TypedGoRoute<SplashRoute>(path: RouterPaths.splash)
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
  String get permissionName => RoutePathsModel.splash.pathName;

  @override
  String get routeLocation => location;
}
