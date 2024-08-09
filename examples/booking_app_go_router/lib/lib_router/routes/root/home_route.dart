part of '../../router.dart';

@TypedGoRoute<HomeRoute>(
  path: RoutesPath.home,
  routes: [],
)
@immutable
class HomeRoute extends GoRouteData implements RouteDataModel {
  const HomeRoute();

  @override
  String get permissionName => throw UnimplementedError();

  @override
  String get routeLocation => location;
}
