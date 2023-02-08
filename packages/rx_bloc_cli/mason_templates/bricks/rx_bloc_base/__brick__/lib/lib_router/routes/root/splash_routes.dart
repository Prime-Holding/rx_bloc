part of '../../router.dart';

@TypedGoRoute<SplashRoute>(path: RoutesPath.splash)
@immutable
class SplashRoute extends GoRouteData implements RouteData {
  const SplashRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SplashPageWithDependencies(
          redirectToLocation: state.queryParams['from'],
        ),
      );

  @override
  String get permissionName => RouteModel.splash.permissionName;

  @override
  String get routeLocation => location;
}
