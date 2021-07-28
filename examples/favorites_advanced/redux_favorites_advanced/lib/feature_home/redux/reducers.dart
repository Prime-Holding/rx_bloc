import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';
//import 'package:favorites_advanced_base/extensions.dart';

import '../models/navigation_state.dart';
import 'actions.dart';

NavigationState navStateReducer(NavigationState state, action) =>
    NavigationState(items: viewReducer(state.items, action));

Reducer<List<NavigationItem>> viewReducer =
    combineReducers<List<NavigationItem>>([
  TypedReducer<List<NavigationItem>, SearchViewAction>(searchViewReducer),
  TypedReducer<List<NavigationItem>, FavoritesViewAction>(favoritesViewReducer),
]);

List<NavigationItem> searchViewReducer(
        List<NavigationItem> items, SearchViewAction action) =>
    changeIsSelected(items, NavigationItemType.search);

List<NavigationItem> favoritesViewReducer(
        List<NavigationItem> items, FavoritesViewAction action) =>
    changeIsSelected(items, NavigationItemType.favorites);

List<NavigationItem> changeIsSelected(
        List<NavigationItem> items, NavigationItemType selected) =>
    items
        .map((item) => item.copyWith(isSelected: item.type == selected))
        .toList();
