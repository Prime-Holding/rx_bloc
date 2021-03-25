import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';

import '../models/puppy_list_state.dart';
import 'actions.dart';

PuppyListState puppyListStateReducer(PuppyListState state, action) =>
    state.copyWith(
      puppies: puppyReducer(state.puppies, action),
      //isError: false,
      isLoading: false,
    );

Reducer<List<Puppy>?> puppyReducer = combineReducers<List<Puppy>?>([
  TypedReducer<List<Puppy>?, PuppiesFetchSucceededAction>(
      puppiesFetchSucceededReducer),
  TypedReducer<List<Puppy>?, ExtraDetailsFetchSucceededAction>(
      extraDetailsFetchSucceededReducer),
]);

List<Puppy>? puppiesFetchSucceededReducer(
        List<Puppy>? puppies, PuppiesFetchSucceededAction action) =>
    action.puppies;

List<Puppy>? extraDetailsFetchSucceededReducer(
    List<Puppy>? puppies, ExtraDetailsFetchSucceededAction action) {
  print(action.puppies);
  return puppies!.mergeWith(action.puppies!);
}
