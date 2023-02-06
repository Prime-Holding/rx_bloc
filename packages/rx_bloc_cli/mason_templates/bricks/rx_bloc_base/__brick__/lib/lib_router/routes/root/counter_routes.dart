part of '../../router.dart';

@TypedGoRoute<CounterRoute>(
  path: RoutePath.counter,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<NotificationsRoute>(
      path: RoutePath.notifications,
    ),
    TypedGoRoute<LoginRoute>(path: RoutePath.login),
    TypedGoRoute<EnterMessageRoute>(path: RoutePath.enterMessage),
    TypedGoRoute<ItemsRoute>(
      path: RoutePath.items,
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ItemDetailsRoute>(
          path: RoutePath.itemDetails,
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
