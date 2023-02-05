part of '../../router.dart';

@TypedGoRoute<SplashRoute>(path: RoutePath.splash)
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
  String get permissionName => RouteModel.splash.permissionName;

  @override
  String get routeLocation => location;
}
