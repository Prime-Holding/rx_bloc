{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
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
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final list = navItemsList(context);
    GoRouter router = GoRouter.of(context);
    GoRouterState routerState = GoRouterState.of(context);
    return Scaffold(
      body: RxBlocListener<RouterBlocType, ErrorModel>(
        state: (bloc) => bloc.states.errors,
        listener: (context, state) => _onError(context, state),
        child: child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: K.bottomNavigationBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(list, router, routerState),
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

  int _getCurrentIndex(
      List<NavMenuItem> list, GoRouter router, GoRouterState goRouterState) {
    var index = list.indexWhere((item) {
      final routePath = router.routeInformationParser.configuration
          .findMatch(goRouterState.location);
      return routePath.fullPath.startsWith(item.routePath);
    });
    return index.isNegative ? 0 : index;
  }

  List<NavMenuItem> navItemsList(BuildContext context) => [
        NavMenuItem(
          title: context.l10n.dashboard,
          icon: context.designSystem.icons.dashboard,
          route: const DashboardRoute(),
          routePath: RoutesPath.dashboard,
        ),
        {{#enable_feature_counter}}
        NavMenuItem(
          title: context.l10n.featureCounter.navCounter,
          icon: context.designSystem.icons.calculateIcon,
          route: const CounterRoute(),
          routePath: RoutesPath.counter,
        ),
        {{/enable_feature_counter}}
        {{#enable_feature_widget_toolkit}}
        NavMenuItem(
          title: context.l10n.featureWidgetToolkit.navWidgetToolkit,
          icon: context.designSystem.icons.widgetIcon,
          route: const WidgetToolkitRoute(),
          routePath: RoutesPath.widgetToolkit,
        ),
        {{/enable_feature_widget_toolkit}}
        {{#enable_feature_deeplinks}}
        NavMenuItem(
          title: context.l10n.featureDeepLink.navLinks,
          icon: context.designSystem.icons.linkIcon,
          route: const DeepLinksRoute(),
          routePath: RoutesPath.deepLinks,
        ),
        {{/enable_feature_deeplinks}}
        NavMenuItem(
          title: context.l10n.navProfile,
          icon: context.designSystem.icons.accountIcon,
          route: const ProfileRoute(),
          routePath: RoutesPath.profile,
        ),
      ];

  void _onError(BuildContext context, ErrorModel errorModel) =>
      showBlurredBottomSheet(
        context: context.read<AppRouter>().rootNavigatorKey.currentContext ??
            context,
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
