import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';

import '../models/navigation_state.dart';
import 'actions.dart';

NavigationState navStateReducer(NavigationState state, action) {
  return NavigationState(item: viewReducer(state.item, action));
}

Reducer<NavigationItemType> viewReducer = combineReducers<NavigationItemType>([
  TypedReducer<NavigationItemType, SearchViewAction>(searchViewReducer),
  TypedReducer<NavigationItemType, FavoritesViewAction>(favoritesViewReducer),
]);

NavigationItemType searchViewReducer(
    NavigationItemType item, SearchViewAction action) {
  return NavigationItemType.search;
}

NavigationItemType favoritesViewReducer(
    NavigationItemType item, FavoritesViewAction action) {
  return NavigationItemType.favorites;
}
