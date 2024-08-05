// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoutes,
    ];

RouteBase get $homeRoutes => GoRouteData.$route(
      path: '/:type',
      factory: $HomeRoutesExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: ':id',
          factory: $HotelDetailsRoutesExtension._fromState,
        ),
      ],
    );

extension $HomeRoutesExtension on HomeRoutes {
  static HomeRoutes _fromState(GoRouterState state) => HomeRoutes(
        _$NavigationItemTypeEnumMap._$fromName(state.pathParameters['type']!),
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(_$NavigationItemTypeEnumMap[type]!)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$NavigationItemTypeEnumMap = {
  NavigationItemType.search: 'search',
  NavigationItemType.favorites: 'favorites',
};

extension $HotelDetailsRoutesExtension on HotelDetailsRoutes {
  static HotelDetailsRoutes _fromState(GoRouterState state) =>
      HotelDetailsRoutes(
        _$NavigationItemTypeEnumMap._$fromName(state.pathParameters['type']!),
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(_$NavigationItemTypeEnumMap[type]!)}/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}
