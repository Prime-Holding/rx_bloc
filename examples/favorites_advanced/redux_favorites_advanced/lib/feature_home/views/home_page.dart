import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/extensions.dart';

import '../../base/models/app_state.dart';
import '../../base/ui_components/puppies_app_bar.dart';

import '../../feature_puppy/favorites/views/favorites_view.dart';
import '../../feature_puppy/search/views/search_view.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PuppiesAppBar(),
        bottomNavigationBar: StoreConnector<AppState, HomeViewModel>(
          converter: (store) => HomeViewModel.from(store),
          distinct: true,
          builder: (_, viewModel) => CurvedNavigationBar(
            color: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            items: viewModel.items
                .map((item) => item.type.asIcon() ?? Container())
                .toList(),
            onTap: (index) => viewModel.onTapNavBar(index),
          ),
        ),
        body: StoreConnector<AppState, HomeViewModel>(
            converter: (store) => HomeViewModel.from(store),
            distinct: true,
            builder: (ctx, viewModel) {
              if (viewModel.error != '') {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.error.toString())));
              }
              if (viewModel.items.toCurrentIndex() == 0) {
                return SearchView();
              } else {
                return FavoritesView();
              }
            }),
      );
}
