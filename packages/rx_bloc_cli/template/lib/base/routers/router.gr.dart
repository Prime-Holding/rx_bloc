// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../../feature_counter/views/home_page.dart' as _i2;

class Router extends _i1.RootStackRouter {
  Router();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomePageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: const _i2.HomePage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes =>
      [_i1.RouteConfig(HomePageRoute.name, path: '/')];
}

class HomePageRoute extends _i1.PageRouteInfo {
  const HomePageRoute() : super(name, path: '/');

  static const String name = 'HomePageRoute';
}
