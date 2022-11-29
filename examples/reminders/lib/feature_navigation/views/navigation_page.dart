import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../blocs/navigation_bloc.dart';
import '../di/navigation_dependencies.dart';

class NavigationPage extends StatelessWidget implements AutoRouteWrapper {
  const NavigationPage({
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: NavigationDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) =>
      RxBlocListener<NavigationBlocType, NavigationTabs>(
        state: (bloc) => bloc.states.tab,
        listener: (context, tab) {
          switch (tab) {
            case NavigationTabs.dashboard:
              context.router.navigate(DashboardRoute());
              break;
            case NavigationTabs.reminders:
              context.router.navigate(const ReminderListRoute());
              break;
          }
        },
        child: AutoTabsScaffold(
          routes: [
            DashboardRoute(),
            const ReminderListRoute(),
          ],
          builder: (context, widget, animation) => widget,
          bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) => context
                .read<NavigationBlocType>()
                .events
                .openTab(_tabFromIndex(index)),
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
        ),
      );

  NavigationTabs _tabFromIndex(int index) {
    switch (index) {
      case 0:
        return NavigationTabs.dashboard;
      case 1:
        return NavigationTabs.reminders;
      default:
        throw UnimplementedError('Unhandled tab index: $index');
    }
  }
}
