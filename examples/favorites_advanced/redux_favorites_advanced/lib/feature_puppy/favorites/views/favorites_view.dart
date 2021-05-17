import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../../base/models/app_state.dart';
import 'favorites_view_model.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: StoreConnector<AppState, FavoritesViewModel>(
          key: const Key(Keys.puppyFavoritesPage),
          distinct: true,
          converter: (store) => FavoritesViewModel.from(store),
          builder: (ctx, viewModel) => PuppyAnimatedListView(
            puppyList: viewModel.puppies,
            onPuppyPressed: (puppy) {
              viewModel.onDetailsPuppy(puppy);
              Navigator.of(context).push(PuppyFlow.route(puppy: puppy));
            },
            onFavorite: (puppy, isFavorite) =>
                viewModel.onToggleFavorite(puppy, isFavorite),
          ),
        ),
      );
}
