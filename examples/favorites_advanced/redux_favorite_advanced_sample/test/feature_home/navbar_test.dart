import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

import '../../lib/feature_home/models/navigation_state.dart';
import '../../lib/feature_home/redux/actions.dart';
import '../../lib/feature_home/redux/reducers.dart';

void main() {
  group("Navigation Bar State", () {
    test("Initial item count should be 2", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      expect(store.state.items.length, 2);
    });
    test("Initial selected item should be Search", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      expect(store.state.selectedPage, NavigationItemType.search);
    });
    test("Initial title should be Search", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      expect(store.state.selectedPage.asTitle(), "Search for Puppies");
    });
    test("Favorites should be selected", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      store.dispatch(FavoritesViewAction());
      expect(store.state.selectedPage, NavigationItemType.favorites);
    });
    test("Favorites should be the title", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      store.dispatch(FavoritesViewAction());
      expect(store.state.selectedPage.asTitle(), "Favorites Puppies");
    });
    test("Search should be selected", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      store.dispatch(FavoritesViewAction());
      store.dispatch(SearchViewAction());
      expect(store.state.selectedPage, NavigationItemType.search);
    });
    test("Search should be the title", () {
      final Store<NavigationState> store = Store<NavigationState>(
        navStateReducer,
        initialState: NavigationState.initialState(),
      );
      store.dispatch(FavoritesViewAction());
      store.dispatch(SearchViewAction());
      expect(store.state.selectedPage.asTitle(), "Search for Puppies");
    });
  });
}
