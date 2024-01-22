import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/models/routes_path.dart';
import '../../lib_router/router.dart';

/// Widget wrapping the bottom navigation bar, allowing the user to navigate
/// between the dashboard and the reminders list
class NavigationPage extends StatelessWidget {
  const NavigationPage({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _toCurrentIndex(context),
          onTap: (index) =>
              context.read<RouterBlocType>().events.goTo(_tabFromIndex(index)),
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

  int _toCurrentIndex(BuildContext context) {
    GoRouter router = GoRouter.of(context);
    final routePath = router.routerDelegate;
    if (routePath.currentConfiguration.fullPath
        .startsWith(RoutesPath.reminders)) {
      return 1;
    }
    return 0;
  }

  RouteDataModel _tabFromIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardRoute();
      case 1:
        return const RemindersRoute();
      default:
        throw UnimplementedError('Unhandled tab index: $index');
    }
  }
}
