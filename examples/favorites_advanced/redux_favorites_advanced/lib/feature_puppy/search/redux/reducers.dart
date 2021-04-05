import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';

import '../models/puppy_list_state.dart';
import 'actions.dart';

PuppyListState puppyListStateReducer(PuppyListState state, action) =>
    state.copyWith(
      isError: isErrorReducer(state: state.isError, action: action),
      puppies: puppyReducer(state.puppies, action),
    );

Reducer<List<Puppy>?> puppyReducer = combineReducers<List<Puppy>?>([
  TypedReducer<List<Puppy>?, PuppiesFetchSucceededAction>(
      puppiesFetchSucceededReducer),
  TypedReducer<List<Puppy>?, ExtraDetailsFetchSucceededAction>(
      extraDetailsFetchSucceededReducer),
  TypedReducer<List<Puppy>?, PuppyFavoriteSucceededAction>(
      puppyFavoriteSucceededReducer),
]);

List<Puppy>? puppiesFetchSucceededReducer(
        List<Puppy>? puppies, PuppiesFetchSucceededAction action) =>
    action.puppies;

List<Puppy>? extraDetailsFetchSucceededReducer(
    List<Puppy>? puppies, ExtraDetailsFetchSucceededAction action) {
  print(action.puppies);
  return puppies!.mergeWith(action.puppies!);
}

List<Puppy>? puppyFavoriteSucceededReducer(
        List<Puppy>? puppies, PuppyFavoriteSucceededAction action) =>
    puppies!.mergeWith([action.puppy]);

bool? isErrorReducer({bool? state, action}) {
  if (action is PuppiesFetchFailedAction) {
    return true;
  }
  if (action is PuppiesFetchSucceededAction) {
    return false;
  }
  return state;
}
