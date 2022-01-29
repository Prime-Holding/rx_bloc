import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/extensions/async_snapshot.dart';
import '../../base/ui_components/puppies_app_bar.dart';
import '../../feature_puppy/blocs/puppies_extra_details_bloc.dart';
import '../../feature_puppy/blocs/puppy_manage_bloc.dart';
import '../../feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import '../../feature_puppy/favorites/views/favorites_page.dart';
import '../../feature_puppy/search/views/search_page.dart';
import '../blocs/navigation_bar_bloc.dart';

part 'home_providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Widget page() => RxMultiBlocProvider(
        providers: _getProviders(),
        child: const HomePage(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PuppiesAppBar(),
        body: RxBlocListener<PuppyManageBlocType, String>(
          state: (bloc) => bloc.states.error,
          listener: (ctx, state) => ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text(state!))),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBody(),
              _buildNavBar(),
            ],
          ),
        ),
      );

  RxBlocBuilder<NavigationBarBlocType, NavigationItem?> _buildBody() =>
      RxBlocBuilder<NavigationBarBlocType, NavigationItem?>(
        key: const ValueKey(Keys.puppyHomePage),
        state: (bloc) => bloc.states.selectedItem,
        builder: (ctx, snapshot, bloc) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: asPage(snapshot),
        ),
      );

  RxBlocBuilder<NavigationBarBlocType, List<NavigationItem>> _buildNavBar() =>
      RxBlocBuilder<NavigationBarBlocType, List<NavigationItem>>(
          state: (bloc) => bloc.states.items,
          builder: (context, snapshot, bloc) =>
              snapshot.build((navItems) => CurvedNavigationBar(
                    index: navItems.toCurrentIndex(),
                    color: Colors.blueAccent,
                    backgroundColor: Colors.transparent,
                    items: navItems
                        .map((item) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: item.asWidget(),
                            ))
                        .toList(),
                    onTap: (index) => bloc.events.selectPage(
                      index == 0
                          ? NavigationItemType.search
                          : NavigationItemType.favorites,
                    ),
                  )));

  Widget asPage(AsyncSnapshot<NavigationItem?> type) {
    if (!type.hasData) {
      return Container();
    }

    switch (type.data!.type) {
      case NavigationItemType.search:
        return const SearchPage();
      case NavigationItemType.favorites:
        return const FavoritesPage();
    }
  }
}

extension NavigationItemToWitget on NavigationItem {
  Widget? asWidget() => type == NavigationItemType.favorites
      ? RxBlocBuilder<FavoritePuppiesBlocType, int>(
          state: (bloc) => bloc.states.count,
          builder: (ctx, snapshot, bloc) =>
              snapshot.hasData && snapshot.data! <= 0
                  ? type.asIcon()!
                  : Badge(
                      padding: const EdgeInsets.all(3),
                      badgeContent: snapshot.build((count) => Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )),
                      badgeColor: Colors.transparent,
                      elevation: 0,
                      child: type.asIcon(),
                    ),
        )
      : type.asIcon();
}
