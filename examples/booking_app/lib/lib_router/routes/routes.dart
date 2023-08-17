part of '../router.dart';

@TypedGoRoute<HomeRoutes>(
  path: RoutesPath.home,
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HotelDetailsRoutes>(
      path: RoutesPath.hotelDetails,
    ),
  ],
)
@immutable
class HomeRoutes extends GoRouteData implements RouteDataModel {
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

@immutable
class HotelDetailsRoutes extends GoRouteData implements RouteDataModel {
  const HotelDetailsRoutes(
    this.type,
    this.id,
  );

  final NavigationItemType type;
  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage(
      key: state.pageKey,
      child: HotelDetailsWithDependencies(
        hotelId: id,
        hotel: state.extra as Hotel?,
      ),
    );
  }

  @override
  String get routeLocation => location;
}
