//TODO move it the desired place in the routing tree Or make it as root route: @TypedGoRoute<DevMenuRoute>(path: path) and run Build Runner - Build
@immutable
class DevMenuRoute extends GoRouteData implements RouteDataModel {
  const DevMenuRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const DevMenuPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.devMenu.permissionName;

  @override
  String get routeLocation => location;
  //TODO execute rebuild and remove this todo - when location is found
}