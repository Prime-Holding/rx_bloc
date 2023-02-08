part of '../../router.dart';

@TypedGoRoute<CounterRoute>(
  path: RoutesPath.counter,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NotificationsRoute>(
      path: RoutesPath.notifications,
    ),
    TypedGoRoute<LoginRoute>(path: RoutesPath.login),
    TypedGoRoute<EnterMessageRoute>(path: RoutesPath.enterMessage),
    TypedGoRoute<ItemsRoute>(
      path: RoutesPath.items,
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ItemDetailsRoute>(
          path: RoutesPath.itemDetails,
        ),
      ],
    ),
  ],
)
@immutable
class CounterRoute extends GoRouteData implements RouteData {
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
