import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/extensions.dart';

import '../../base/models/app_state.dart';
import '../../base/ui_components/puppies_app_bar.dart';

import '../../feature_puppy/favorites/views/favorites_view.dart';
import '../../feature_puppy/search/views/search_view.dart';

import '../redux/actions.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PuppiesAppBar(),
        bottomNavigationBar: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.from(store),
          distinct: true,
          builder: (_, viewModel) => CurvedNavigationBar(
            color: Colors.blueAccent,
            backgroundColor: Colors.transparent,
            items: viewModel.items.map((item) => item.type.asIcon()).toList(),
            onTap: (index) => viewModel.onTapNavBar(index),
          ),
        ),
        body: StoreConnector<AppState, _ViewModel>(
          converter: (store) => _ViewModel.from(store),
          distinct: true,
          builder: (_, viewModel) => viewModel.items.toCurrentIndex() == 0
              ? SearchView()
              : FavoritesView(),
        ),
      );
}

class _ViewModel {
  _ViewModel({@required this.items, this.onTapNavBar});

  factory _ViewModel.from(Store<AppState> store) {
    void _onTapNavBar(int index) {
      store.dispatch(
        index == 0 ? SearchViewAction() : FavoritesViewAction(),
      );
    }

    return _ViewModel(
      items: store.state.navigationState.items,
      onTapNavBar: _onTapNavBar,
    );
  }

  final List<NavigationItem> items;
  final Function(int) onTapNavBar;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          onTapNavBar == other.onTapNavBar;

  @override
  int get hashCode => items.hashCode ^ onTapNavBar.hashCode;
}
