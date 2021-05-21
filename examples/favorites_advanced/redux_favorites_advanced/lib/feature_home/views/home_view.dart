import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';

import '../../base/models/app_state.dart';
import '../../base/ui_components/puppies_app_bar.dart';

import '../../feature_puppy/favorites/views/favorites_view.dart';
import '../../feature_puppy/search/views/search_view.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PuppiesAppBar(),
        body: StoreConnector<AppState, HomeViewModel>(
          onDidChange: (viewModel, _) {
            if (viewModel!.error != '') {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(viewModel.error.toString())));
            }
          },
          converter: (store) => HomeViewModel.from(store),
          distinct: true,
          builder: (_, viewModel) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (viewModel.items.toCurrentIndex() == 0)
                SearchView()
              else
                FavoritesView(),
              _buildNavBar(viewModel),
            ],
          ),
        ),
      );

  Widget _buildNavBar(HomeViewModel viewModel) => CurvedNavigationBar(
        color: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        items: viewModel.items
            .map((item) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: item.asWidget(),
                ))
            .toList(),
        onTap: (index) => viewModel.onTapNavBar(index),
      );
}

extension NavigationItemToWidget on NavigationItem {
  Widget? asWidget() => type == NavigationItemType.favorites
      ? StoreConnector<AppState, HomeViewModel>(
          converter: (store) => HomeViewModel.from(store),
          builder: (_, viewModel) => viewModel.favCount <= 0
              ? type.asIcon()!
              : Badge(
                  padding: const EdgeInsets.all(3),
                  badgeContent: Text(
                    viewModel.favCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  child: type.asIcon(),
                ),
        )
      : type.asIcon();
}
