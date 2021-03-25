import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../../../base/models/app_state.dart';
import '../../../feature_puppy/search/redux/actions.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: StoreConnector<AppState, _ViewModel>(
          key: const Key(Keys.puppySearchPage),
          onInit: (store) => store.dispatch(PuppiesFetchRequestedAction()),
          converter: (store) => _ViewModel.from(store),
          builder: (_, viewModel) => (viewModel.isError!)
              ? ErrorRetryWidget(
                  onReloadTap: () => viewModel.onRefreshFetch(),
                )
              : (viewModel.puppies!.isEmpty)
                  ? LoadingWidget()
                  : RefreshIndicator(
                      onRefresh: () {
                        debugPrint(viewModel.puppies?.length.toString());
                        viewModel.onRefreshFetch();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SafeArea(
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
                      ),
                    ),
        ),
      );
}

class _ViewModel {
  _ViewModel({
    required this.isError,
    required this.puppies,
    required this.onRefreshFetch,
    required this.onExtraDetailsFetch,
  });

  factory _ViewModel.from(Store<AppState> store) {
    void _onRefreshFetch() {
      store.dispatch(PuppiesFetchRequestedAction());
    }

    void _onExtraDetailsFetch(Puppy puppy) {
      //print(puppy);
      store.dispatch(ExtraDetailsFetchRequestedAction(puppy: puppy));
    }

    return _ViewModel(
      isError: store.state.puppyListState.isError,
      puppies: store.state.puppyListState.puppies,
      onRefreshFetch: _onRefreshFetch,
      onExtraDetailsFetch: _onExtraDetailsFetch,
    );
  }

  final bool? isError;
  final List<Puppy>? puppies;
  final Function onRefreshFetch;
  final Function onExtraDetailsFetch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          isError == other.isError &&
          puppies == other.puppies &&
          onRefreshFetch == other.onRefreshFetch &&
          onExtraDetailsFetch == other.onExtraDetailsFetch;

  @override
  int get hashCode =>
      isError.hashCode ^
      puppies.hashCode ^
      onRefreshFetch.hashCode ^
      onExtraDetailsFetch.hashCode;
}
