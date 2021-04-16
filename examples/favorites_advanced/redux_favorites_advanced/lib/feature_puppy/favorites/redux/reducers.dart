import 'package:favorites_advanced_base/models.dart';

import '../models/favorite_list_state.dart';
import 'actions.dart';

FavoriteListState favoriteListStateReducer(FavoriteListState state, action) =>
    state.copyWith(
      isError: isErrorReducer(state: state.isError, action: action),
      puppies: favoritePuppyReducer(state: state.puppies, action: action),
    );

List<Puppy>? favoritePuppyReducer({List<Puppy>? state, action}) {
  // if (action is AddPuppyToFavoritesListAction) {
  //   return state!.mergeWith([action.puppy]);
  // }
  // if (action is RemovePuppyFromFavoritesListAction) {
  //   final state2 = state!.remove(action.puppy);
  // }
  if (action is AddPuppyToFavoritesListAction ||
      action is RemovePuppyFromFavoritesListAction) {
    //print(action);
    print(action.puppy);
    print(state);
    return state!.manageFavoriteList([action.puppy]);
  }
  return state;
}

bool? isErrorReducer({bool? state, action}) {
  print(state);
  // if (action is PuppiesFetchFailedAction) {
  //   return true;
  // }
  // if (action is PuppiesFetchSucceededAction) {
  //   return false;
  // }
  return state;
}
