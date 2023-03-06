// {{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/models/routes_path.dart';
import '../../lib_router/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final list = navItemsList(context);
    GoRouter router = GoRouter.of(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(list, router),
        onTap: (index) =>
            context.read<RouterBlocType>().events.go(list[index].route),
        items: list
            .map(
              (item) => BottomNavigationBarItem(
                label: item.title,
                icon: item.icon,
              ),
            )
            .toList(),
      ),
    );
  }

  int _getCurrentIndex(List<NavMenuItem> list, GoRouter router) {
    int index = list.indexWhere((item) {
      final routePath =
          router.routeInformationParser.matcher.findMatch(router.location);
      return routePath.fullpath.startsWith(item.routePath);
    });
    return index.isNegative ? 0 : index;
  }

  List<NavMenuItem> navItemsList(BuildContext context) => [
        NavMenuItem(
          title: context.l10n.navCounter,
          icon: context.designSystem.icons.calculateIcon,
          route: const CounterRoute(),
          routePath: RoutesPath.counter,
        ),
        NavMenuItem(
          title: context.l10n.navLinks,
          icon: context.designSystem.icons.linkIcon,
          route: const DeepLinksRoute(),
          routePath: RoutesPath.deepLinks,
        ),
        NavMenuItem(
          title: context.l10n.navProfile,
          icon: context.designSystem.icons.accountIcon,
          route: const ProfileRoute(),
          routePath: RoutesPath.profile,
        ),
      ];
}

class NavMenuItem {
  NavMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.routePath,
  });

  final String title;
  final Icon icon;
  final RouteDataModel route;
  final String routePath;
}
