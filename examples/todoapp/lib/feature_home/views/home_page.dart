// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
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
      body: RxBlocListener<RouterBlocType, ErrorModel>(
        state: (bloc) => bloc.states.errors,
        listener: (context, state) => _onError(context, state),
        child: BranchContainer(
          currentIndex: currentIndex,
          children: branchNavigators,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  List<NavMenuItem> navItemsList(BuildContext context) => [
        NavMenuItem(
          title: context.l10n.todos,
          icon: context.designSystem.icons.todos,
          route: const TodoListRoute(),
          routePath: RoutesPath.todoList,
        ),
        NavMenuItem(
          title: context.l10n.stats,
          icon: context.designSystem.icons.stats,
          route: const StatsRoute(),
          routePath: RoutesPath.stats,
        ),
      ];

  void _onError(BuildContext context, ErrorModel errorModel) =>
      showBlurredBottomSheet(
        context: AppRouter.rootNavigatorKey.currentContext ?? context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: errorModel.translate(context),
          messageState: MessagePanelState.neutral,
        ),
      );
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
