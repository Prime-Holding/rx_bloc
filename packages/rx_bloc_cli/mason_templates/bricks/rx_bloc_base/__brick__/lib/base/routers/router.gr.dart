// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import '../../feature_counter/views/counter_page.dart' as _i2;

class Router extends _i1.RootStackRouter {
  Router();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    CounterPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: const _i2.CounterPage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes =>
      [_i1.RouteConfig(CounterPageRoute.name, path: '/')];
}

class CounterPageRoute extends _i1.PageRouteInfo {
  const CounterPageRoute() : super(name, path: '/');

  static const String name = 'CounterPageRoute';
}
