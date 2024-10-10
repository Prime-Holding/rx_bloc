import 'package:badges/badges.dart' as badges;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart' as keys;
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../base/common_blocs/hotel_manage_bloc.dart';
import '../../base/extensions/async_snapshot.dart';
import '../../base/ui_components/favorite_message_listener.dart';
import '../../base/ui_components/hotels_app_bar.dart';
import '../../feature_hotel_favorites/blocs/hotel_favorites_bloc.dart';
import '../../feature_hotel_favorites/views/hotel_favorites_page.dart';
import '../../feature_hotel_search/views/hotel_search_page.dart';
import '../blocs/navigation_bar_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const HotelsAppBar(),
        body: Column(
          children: [
            const FavoriteMessageListener(overrideMargins: true),
            Expanded(
              child: RxBlocListener<HotelManageBlocType, String>(
                state: (bloc) => bloc.states.error,
                listener: (ctx, state) =>
                    ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    key: keys.errorSnackbarKey,
                    content: Text(state),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    RxBlocBuilder<NavigationBarBlocType, NavigationItem?>(
                      state: (bloc) => bloc.states.selectedItem,
                      builder: (ctx, snapshot, bloc) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: asPage(snapshot),
                      ),
                    ),
                    RxBlocBuilder<NavigationBarBlocType, List<NavigationItem>>(
                      state: (bloc) => bloc.states.items,
                      builder: (context, snapshot, bloc) => snapshot.build(
                        (navItems) => CurvedNavigationBar(
                          index: navItems.toCurrentIndex(),
                          color: Colors.blueAccent,
                          backgroundColor: Colors.transparent,
                          items: navItems
                              .map(
                                (item) => GestureDetector(
                                  key: item.type == NavigationItemType.search
                                      ? keys.searchNavButtonKey
                                      : keys.favoritesNavButtonTapKey,
                                  onTap: () => bloc.events.selectPage(
                                    item.type == NavigationItemType.search
                                        ? NavigationItemType.search
                                        : NavigationItemType.favorites,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: item.asWidget(),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget asPage(AsyncSnapshot<NavigationItem?> type) {
    if (!type.hasData) {
      return Container();
    }

    switch (type.data!.type) {
      case NavigationItemType.search:
        return const HotelSearchPage(key: keys.searchPageKey);
      case NavigationItemType.favorites:
        return const HotelFavoritesPage(key: keys.favoritesPageKey);
    }
  }
}

extension NavigationItemToWidget on NavigationItem {
  Widget? asWidget() => type == NavigationItemType.favorites
      ? RxBlocBuilder<HotelFavoritesBlocType, int>(
          state: (bloc) => bloc.states.count,
          builder: (ctx, snapshot, bloc) =>
              snapshot.hasData && snapshot.data! <= 0
                  ? type.asIcon()!
                  : badges.Badge(
                      badgeStyle: const badges.BadgeStyle(
                        padding: EdgeInsets.all(5),
                        badgeColor: Colors.white,
                        elevation: 0,
                      ),
                      badgeContent: snapshot.build(
                        (count) => Text(
                          key: keys.favoritesNavButtonTextKey,
                          count.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      child: type.asIcon(),
                    ),
        )
      : type.asIcon();
}
