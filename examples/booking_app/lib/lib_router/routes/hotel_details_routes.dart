part of '../router.dart';

@immutable
class HotelDetailsRoutes extends GoRouteData implements RouteData {
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
