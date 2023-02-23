part of '../../router.dart';

@TypedGoRoute<CounterRoute>(path: RoutesPath.counter)
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
