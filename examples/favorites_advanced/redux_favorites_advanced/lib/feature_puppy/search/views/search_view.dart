import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/redux/actions.dart';
import '../../../base/models/app_state.dart';
import 'package:redux_favorite_advanced_sample/feature_puppy/search/models/puppy_list_state.dart';
import 'package:redux_saga/redux_saga.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: StoreConnector<AppState, _ViewModel>(
          key: const Key(Keys.puppySearchPage),
          onInit: (store) => store.dispatch(PuppiesFetchRequestedAction()),
          converter: (store) => _ViewModel.from(store),
          builder: (_, viewModel) {
            //print(viewModel.puppies);
            print(viewModel.puppies!.length);
            if (viewModel.puppies!.isEmpty) {
              return LoadingWidget();
            } else {
              return SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 67),
                  itemCount: viewModel.puppies!.length,
                  itemBuilder: (ctx, index) {
                    final item = viewModel.puppies![index];
                    return PuppyCard(
                      key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                      onVisible: (puppy) =>
                          viewModel.onExtraDetailsFetch(puppy),
                      puppy: item,
                      onCardPressed: (puppy) {},
                      onFavorite: (puppy, isFavorite) {},
                    );
                  },
                ),
              );
            }
          },
        ),
      );
}

class _ViewModel {
  _ViewModel({required this.puppies, required this.onExtraDetailsFetch});

  factory _ViewModel.from(Store<AppState> store) {
    void _onExtraDetailsFetch(Puppy puppy) {
      store.dispatch(ExtraDetailsFetchRequestedAction(puppy: puppy));
    }

    return _ViewModel(
      puppies: store.state.puppyListState.puppies,
      onExtraDetailsFetch: _onExtraDetailsFetch,
    );
  }

  final List<Puppy>? puppies;
  final Function onExtraDetailsFetch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          puppies == other.puppies &&
          onExtraDetailsFetch == other.onExtraDetailsFetch;

  @override
  int get hashCode => puppies.hashCode ^ onExtraDetailsFetch.hashCode;
}
