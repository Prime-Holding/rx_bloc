// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $homeRoutes,
    ];

GoRoute get $homeRoutes => GoRouteData.$route(
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
        _$NavigationItemTypeEnumMap._$fromName(state.params['type']!),
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(_$NavigationItemTypeEnumMap[type]!)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

extension $HotelDetailsRoutesExtension on HotelDetailsRoutes {
  static HotelDetailsRoutes _fromState(GoRouterState state) =>
      HotelDetailsRoutes(
        _$NavigationItemTypeEnumMap._$fromName(state.params['type']!),
        state.params['id']!,
      );

  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(_$NavigationItemTypeEnumMap[type]!)}/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

const _$NavigationItemTypeEnumMap = {
  NavigationItemType.search: 'search',
  NavigationItemType.favorites: 'favorites',
};

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}
