part of '../../router.dart';

/// Route used for navigating to the splash page
@TypedGoRoute<SplashRoute>(path: RoutesPath.splash)
@immutable
class SplashRoute extends GoRouteData implements RouteDataModel {
  const SplashRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: SplashPageWithDependencies(
          redirectToLocation: state.uri.queryParameters['from'],
        ),
      );

  @override
  String get routeLocation => location;
}
