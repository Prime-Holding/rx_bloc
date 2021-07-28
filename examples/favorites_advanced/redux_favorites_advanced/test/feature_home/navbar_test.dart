import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/extensions.dart';

import 'package:redux_favorite_advanced_sample/base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/base/redux/app_reducer.dart';
import 'package:redux_favorite_advanced_sample/feature_home/redux/actions.dart';

import '../stubs.dart';

void main() {
  late Store<AppState> store;

  setUp(() {
    store = Store<AppState>(
      appReducer,
      initialState: AppState.initialState(),
    );
  });

  group('Navigation Bar State', () {
    test('Initial item count should be 2', () {
      expect(store.state.navigationState.items.length, 2);
    });
    test('Initial selected item should be Search', () {
      // expect(
      //   store.state.navigationState,
      //   const NavigationState(items: [
      //     NavigationStub.searchSelected,
      //     NavigationStub.favoritesNotSelected,
      //   ]),
      // );
      expect(
        store.state.navigationState.selectedPage,
        NavigationItemType.search,
      );
    });
    test('Initial title should be Search', () {
      expect(
        store.state.navigationState.selectedPage.asTitle(),
        NavigationStub.searchTitle,
      );
    });
    test('Favorites should be selected', () {
      store.dispatch(FavoritesViewAction());
      expect(
        store.state.navigationState.selectedPage,
        NavigationItemType.favorites,
      );
    });
    test('Favorites should be the title', () {
      store.dispatch(FavoritesViewAction());
      expect(
        store.state.navigationState.selectedPage.asTitle(),
        NavigationStub.favoritesTitle,
      );
    });
    test('Search should be selected', () {
      store..dispatch(FavoritesViewAction())..dispatch(SearchViewAction());
      expect(
        store.state.navigationState.selectedPage,
        NavigationItemType.search,
      );
    });
    test('Search should be the title', () {
      store..dispatch(FavoritesViewAction())..dispatch(SearchViewAction());
      expect(
        store.state.navigationState.selectedPage.asTitle(),
        NavigationStub.searchTitle,
      );
    });
  });
}
