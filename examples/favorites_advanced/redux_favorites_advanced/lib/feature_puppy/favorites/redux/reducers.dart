import 'package:favorites_advanced_base/models.dart';

import '../models/favorite_list_state.dart';
import 'actions.dart';

FavoriteListState favoriteListStateReducer(FavoriteListState state, action) =>
    FavoriteListState(
      puppies: favoritePuppyReducer(state: state.puppies, action: action),
    );

List<Puppy> favoritePuppyReducer({required List<Puppy> state, action}) {
  if (action is PuppyToFavoritesListAction) {
    return state.manageFavoriteList([action.puppy]);
  }
  return state;
}
