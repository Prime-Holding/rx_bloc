import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../../base/models/app_state.dart';
import '../../../feature_puppy/search/redux/actions.dart';
import 'search_view_model.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: StoreConnector<AppState, SearchViewModel>(
          key: const Key(Keys.puppySearchPage),
          distinct: true,
          onInit: (store) => store.state.puppyListState.puppies.isEmpty
              ? store.dispatch(PuppiesFetchRequestedAction())
              : null,
          converter: (store) => SearchViewModel.from(store),
          builder: (_, viewModel) => (viewModel.isLoading)
              ? LoadingWidget()
              : (viewModel.isError)
                  ? ErrorRetryWidget(
                      onReloadTap: () => viewModel.onErrorReload(),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        viewModel.onRefreshFetch();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SafeArea(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 67),
                          itemCount: viewModel.puppies.length,
                          itemBuilder: (ctx, index) {
                            final item = viewModel.puppies[index];
                            return PuppyCard(
                              key: Key('${Keys.puppyCardNamePrefix}${item.id}'),
                              onVisible: (puppy) =>
                                  viewModel.onExtraDetailsFetch(puppy),
                              puppy: item,
                              onCardPressed: (puppy) {
                                viewModel.onDetailsPuppy(puppy);
                                Navigator.of(context).push(PuppyFlow.route());
                              },
                              onFavorite: (puppy, isFavorite) =>
                                  viewModel.onToggleFavorite(puppy, isFavorite),
                            );
                          },
                        ),
                      ),
                    ),
        ),
      );
}
