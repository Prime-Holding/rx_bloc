import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';

import 'package:favorites_advanced_base/models.dart';

import '../../../base/models/app_state.dart';
import '../../../feature_puppy/search/redux/actions.dart';

class SearchViewModel extends Equatable {
  const SearchViewModel({
    required this.isError,
    required this.puppies,
    required this.onRefreshFetch,
    required this.onExtraDetailsFetch,
    required this.onToggleFavorite,
  });

  factory SearchViewModel.from(Store<AppState> store) {
    void _onRefreshFetch() {
      store.dispatch(PuppiesFetchRequestedAction());
    }

    void _onExtraDetailsFetch(Puppy puppy) {
      print(puppy);
      store.dispatch(ExtraDetailsFetchRequestedAction(puppy: puppy));
    }

    void _onToggleFavorite(Puppy puppy, bool isFavorite) {
      store.dispatch(PuppyToggleFavoriteAction(
        puppy: puppy,
        isFavorite: isFavorite,
      ));
    }

    return SearchViewModel(
      isError: store.state.puppyListState.isError,
      puppies: store.state.puppyListState.puppies,
      onRefreshFetch: _onRefreshFetch,
      onExtraDetailsFetch: _onExtraDetailsFetch,
      onToggleFavorite: _onToggleFavorite,
    );
  }

  final bool isError;
  final List<Puppy> puppies;
  final Function onRefreshFetch;
  final Function onExtraDetailsFetch;
  final Function onToggleFavorite;

  @override
  List<Object> get props =>
      [isError, puppies, onRefreshFetch, onExtraDetailsFetch, onToggleFavorite];
}
