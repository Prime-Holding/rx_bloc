part of '../../router.dart';

@TypedGoRoute<ItemsRoute>(
  path: RoutesPath.items,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ItemDetailsRoute>(
      path: RoutesPath.itemDetails,
    ),
    TypedGoRoute<EnterMessageRoute>(
      path: RoutesPath.enterMessage,
    ),
  ],
)
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
  String get permissionName => RouteModel.items.permissionName;

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
  String get permissionName => RouteModel.itemDetails.permissionName;

  @override
  String get routeLocation => location;
}
