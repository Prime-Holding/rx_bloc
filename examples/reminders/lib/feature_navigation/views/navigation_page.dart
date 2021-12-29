import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_extensions.dart';

import '../di/navigation_dependencies.dart';

class NavigationPage extends StatelessWidget implements AutoRouteWrapper {
  const NavigationPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: NavigationDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => AutoTabsScaffold(
        routes: const [
          DashboardRoute(),
          ReminderListRoute(),
        ],
        builder: (context, widget, animation) => widget,
        bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) => tabsRouter.setActiveIndex(index),
          items: const [
            BottomNavigationBarItem(
              label: 'Dashboard',
              icon: Icon(Icons.dashboard),
            ),
            BottomNavigationBarItem(
              label: 'Reminders',
              icon: Icon(Icons.list),
            ),
          ],
        ),
      );
}
