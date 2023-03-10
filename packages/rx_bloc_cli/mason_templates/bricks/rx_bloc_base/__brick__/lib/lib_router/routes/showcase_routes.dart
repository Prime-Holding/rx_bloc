part of '../router.dart';

{{#enable_feature_counter}}
@TypedGoRoute<CounterRoute>(path: RoutesPath.counter)
@immutable
class CounterRoute extends GoRouteData implements RouteDataModel {
  const CounterRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const CounterPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.counter.permissionName;

  @override
  String get routeLocation => location;
}
{{/enable_feature_counter}}


{{#enable_feature_deeplinks}}
@TypedGoRoute<DeepLinksRoute>(
  path: RoutesPath.deepLinks,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<DeepLinkDetailsRoute>(
      path: RoutesPath.deepLinkDetails,
    ),
    TypedGoRoute<EnterMessageRoute>(
      path: RoutesPath.enterMessage,
    ),
  ],
)
@immutable
class DeepLinksRoute extends GoRouteData implements RouteDataModel {
  const DeepLinksRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const DeepLinkListPageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.deepLinks.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class DeepLinkDetailsRoute extends GoRouteData implements RouteDataModel {
  const DeepLinkDetailsRoute(this.id);

  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: DeepLinkDetailsWithDependencies(
          deepLinkId: id,
          deepLink: state.extra as DeepLinkModel?,
        ),
      );

  @override
  String get permissionName => RouteModel.deepLinkDetails.permissionName;

  @override
  String get routeLocation => location;
}

@immutable
class EnterMessageRoute extends GoRouteData implements RouteDataModel {
  const EnterMessageRoute();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const EnterMessageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.enterMessage.permissionName;

  @override
  String get routeLocation => location;
}
{{/enable_feature_deeplinks}}