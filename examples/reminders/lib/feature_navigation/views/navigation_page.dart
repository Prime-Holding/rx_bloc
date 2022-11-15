import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
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
  Widget build(BuildContext context) => RxBlocListener<NavigationBlocType, int>(
        state: (bloc) => bloc.states.tabIndex,
        listener: (context, index) {
          switch (index) {
            case 0:
              context.router.navigate(DashboardRoute());
              break;
            case 1:
              context.router.navigate(const ReminderListRoute());
              break;
          }
        },
        child: RxBlocListener<NavigationBlocType, String>(
          state: (bloc) => bloc.states.errors,
          listener: (context, error) {
            showOkAlertDialog(
              context: context,
              message: error,
            );
          },
          child: AutoTabsScaffold(
            routes: [
              DashboardRoute(),
              const ReminderListRoute(),
            ],
            builder: (context, widget, animation) => widget,
            bottomNavigationBuilder: (context, tabsRouter) =>
                BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) =>
                  context.read<NavigationBlocType>().events.openTab(index),
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
        ),
      );
}
