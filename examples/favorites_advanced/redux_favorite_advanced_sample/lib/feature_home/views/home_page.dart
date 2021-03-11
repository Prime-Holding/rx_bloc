import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:favorites_advanced_base/extensions.dart';
import 'package:favorites_advanced_base/models.dart';

import '../../feature_puppy/favorites/views/favorites_view.dart';
import '../../feature_puppy/search/views/search_view.dart';

import '../models/navigation_state.dart';
import '../redux/reducers.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Store<NavigationState> store = Store<NavigationState>(
      navStateReducer,
      initialState: NavigationState.initialState(),
    );
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        items: [
          NavigationItemType.search.asIcon(),
          NavigationItemType.favorites.asIcon(),
        ],
        onTap: (index) {},
      ),
      body: StoreProvider<NavigationState>(
        store: store,
        child: StoreBuilder<NavigationState>(
          builder: (BuildContext context, Store<NavigationState> store) =>
              store.state.item == NavigationItemType.search
                  ? SearchView()
                  : FavoritesView(),
        ),
      ),
    );
  }
}
