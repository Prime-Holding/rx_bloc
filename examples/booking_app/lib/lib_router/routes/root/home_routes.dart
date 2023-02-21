part of '../../router.dart';

@TypedGoRoute<HomeRoutes>(
  path: RoutesPath.home,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HotelDetailsRoutes>(
      path: RoutesPath.hotelDetails,
    ),
  ],
)
@immutable
class HomeRoutes extends GoRouteData implements RouteData {
  const HomeRoutes(this.type);

  final NavigationItemType type;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: HomePageWithDependencies(
          navigationType: type,
        ),
      );

  @override
  String get routeLocation => location;
}
