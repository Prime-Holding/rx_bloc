{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/models/routes_path.dart';
import '../../lib_router/router.dart';
import '../extensions/navigation_item_type_model_extentions.dart';
import '../models/navigation_item_type_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _toCurrentIndex(context),
          onTap: (index) =>
              context.read<RouterBlocType>().events.goTo(_tabFromIndex(index)),
          items: NavigationItemTypeModel.values
              .map(
                (item) => BottomNavigationBarItem(
                  label: item.getTitle(context),
                  icon: item.getIcon(context),
                ),
              )
              .toList(),
        ),
      );

  int _toCurrentIndex(BuildContext context) {
    GoRouter router = GoRouter.of(context);
    final routePath =
        router.routeInformationParser.matcher.findMatch(router.location);
    if (routePath.fullpath.startsWith(RoutesPath.items)) {
      return 1;
    }
    if (routePath.fullpath.startsWith(RoutesPath.profile)) {
      return 2;
    }
    return 0;
  }

  RouteData _tabFromIndex(int index) {
    switch (index) {
      case 0:
        return const CounterRoute();
      case 1:
        return const ItemsRoute();
      case 2:
        return const ProfileRoute();
      default:
        throw UnimplementedError('Unhandled tab index: $index');
    }
  }
}
