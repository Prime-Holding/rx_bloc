{{> licence.dart }}

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../lib_router/models/route_data_model.dart';
import '../../lib_router/models/routes_path.dart';
import '../../lib_router/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.currentIndex,
    required this.branchNavigators,
    required this.onNavigationItemSelected,
    super.key,
  });

  final int currentIndex;
  final List<Widget> branchNavigators;
  final void Function(int) onNavigationItemSelected;

  @override
  Widget build(BuildContext context) {
    final list = navItemsList(context);
    return Scaffold(
       body: BranchContainer(
        currentIndex: currentIndex,
        children: branchNavigators,
      ),
      bottomNavigationBar: list.length == 1
          ? null
          : Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: context.designSystem.colors.tintColor
                        .withValues(alpha: 0.3),
                    blurRadius: context.designSystem.spacing.l,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                key: K.bottomNavigationBar,
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: onNavigationItemSelected,
                items: list
                    .map(
                      (item) => BottomNavigationBarItem(
                        label: item.title,
                        icon: item.icon,
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  List<NavMenuItem> navItemsList(BuildContext context) => [
        NavMenuItem(
          title: context.l10n.dashboard,
          icon: context.designSystem.icons.dashboard,
          route: const DashboardRoute(),
          routePath: RoutesPath.dashboard,
        ),{{#has_showcase}}
        NavMenuItem(
          title: context.l10n.navShowcase,
          icon: context.designSystem.icons.showcase,
          route: const ShowcaseRoute(),
          routePath: RoutesPath.showcase,
        ),{{/has_showcase}}
        {{#enable_profile}}
        NavMenuItem(
          title: context.l10n.navProfile,
          icon: context.designSystem.icons.accountIcon,
          route: const ProfileRoute(),
          routePath: RoutesPath.profile,
        ),{{/enable_profile}}
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

class BranchContainer extends StatelessWidget {
  const BranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
    });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        final isCurrentIndex = index == currentIndex;
        return Opacity(
          opacity: isCurrentIndex ? 1 : 0,
          child: IgnorePointer(
            ignoring: !isCurrentIndex,
            child: TickerMode(
              enabled: isCurrentIndex,
              child: navigator,
            ),
          ),
        );
      },
    ).toList());
  }
}
