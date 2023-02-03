part of '../router.dart';

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
  String get permissionName => RoutePathsModel.items.permissionName;

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
  String get permissionName => RoutePathsModel.itemDetails.permissionName;

  @override
  String get routeLocation => location;
}
