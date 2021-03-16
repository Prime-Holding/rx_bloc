import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/extensions.dart';

import '../../base/ui_components/puppies_app_bar.dart';

import '../../feature_puppy/favorites/views/favorites_view.dart';
import '../../feature_puppy/search/views/search_view.dart';

import '../models/navigation_state.dart';
import '../redux/actions.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.store);

  final Store<NavigationState> store;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PuppiesAppBar(),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.blueAccent,
          backgroundColor: Colors.white,
          items: store.state.items.map((item) => item.type.asIcon()).toList(),
          onTap: (index) => store.dispatch(
            index == 0 ? SearchViewAction() : FavoritesViewAction(),
          ),
        ),
        body: StoreBuilder<NavigationState>(
          builder: (_, store) => store.state.items.toCurrentIndex() == 0
              ? SearchView()
              : FavoritesView(),
        ),
      );
}
