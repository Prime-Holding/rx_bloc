import 'package:badges/badges.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppies_extra_details_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_sample/feature_puppy/favorites/views/favorites_page.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:bloc_sample/feature_puppy/search/views/search_page.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/extensions.dart';

import 'package:bloc_sample/base/ui_components/puppies_app_bar.dart';
import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

part 'home_providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Widget page() => MultiBlocProvider(
        providers: _getProviders(),
        child: const HomePage(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PuppiesAppBar(),
        body: BlocListener<FavoritePuppiesBloc, FavoritePuppiesState>(
          listener: (ctx, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(ctx)
                  .showSnackBar(SnackBar(content: Text(state.error ?? '')));
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _buildBody(),
              _buildNavBar(),
            ],
          ),
        ),
      );

  BlocBuilder<NavigationBarBloc, NavigationBarState> _buildBody() =>
      BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: asPage(state),
        ),
      );

  Widget asPage(NavigationBarState state) {
    switch (state.selectedItem.type) {
      case NavigationItemType.search:
        return SearchPage();
      case NavigationItemType.favorites:
        return FavoritesPage();
    }
  }

  BlocBuilder<NavigationBarBloc, NavigationBarState> _buildNavBar() =>
      BlocBuilder<NavigationBarBloc, NavigationBarState>(
        builder: (context, state) => CurvedNavigationBar(
            index: state.items.toCurrentIndex(),
            color: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            items: state.items
                .map((item) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: item.asWidget(),
                    ))
                .toList(),
            onTap: (index) => context.read<NavigationBarBloc>().add(
                  NavigationBarEvent(
                    index == 0
                        ? NavigationItemType.search
                        : NavigationItemType.favorites,
                  ),
                )),
      );
}

extension NavigationItemToWidget on NavigationItem {
  Widget? asWidget() => type == NavigationItemType.favorites
      ? BlocBuilder<FavoritePuppiesBloc, FavoritePuppiesState>(
          builder: (context, state) => state.favoritePuppies.isEmpty
              ? type.asIcon()!
              : Badge(
                  padding: const EdgeInsets.all(3),
                  badgeContent: Text(state.favoritePuppies.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      )),
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  child: type.asIcon(),
                ),
        )
      : type.asIcon();
}
