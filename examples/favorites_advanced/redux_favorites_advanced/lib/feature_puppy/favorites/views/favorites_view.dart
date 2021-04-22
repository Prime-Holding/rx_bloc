import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:declarative_animated_list/declarative_animated_list.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../../../base/models/app_state.dart';
import '../../list/ui_components/puppy_animated_list_view.dart';
import 'favorites_view_model.dart';

import '../../../feature_puppy/search/redux/actions.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return Center(
      // child: PuppyAnimatedListView(
      //   puppyList: store.state.favoriteListState.puppies,
      //   onFavorite: (puppy, isFavorite) {
      //     store.dispatch(PuppyToggleFavoriteAction(
      //       puppy: puppy,
      //       isFavorite: isFavorite,
      //     ));
      //   },
      // ),
      child: StoreConnector<AppState, FavoritesViewModel>(
        key: const Key(Keys.puppyFavoritesPage),
        distinct: true,
        //rebuildOnChange: false,
        //ignoreChange: (state) => state.favoriteListState.puppies.isNotEmpty,
        converter: (store) => FavoritesViewModel.from(store),
        // builder: (ctx, viewModel) => PuppyAnimatedListView(
        //   puppyList: viewModel.puppies,
        //   onFavorite: viewModel.onToggleFavorite,
        // ),
        builder: (ctx, viewModel) => DeclarativeList<Puppy>(
          items: viewModel.puppies,
          itemBuilder: (ctx, puppy, index, animation) =>
              _puppyTile(puppy, animation, viewModel),
          removeBuilder: (ctx, puppy, index, animation) =>
              _puppyTile(puppy, animation, viewModel),
        ),
      ),
    );
  }

  Widget _puppyTile(Puppy puppy, Animation<double> animation,
          FavoritesViewModel viewModel) =>
      SizeTransition(
        sizeFactor: animation,
        child: PuppyCard(
          key: Key('${Keys.puppyCardNamePrefix}${puppy.id}'),
          puppy: puppy,
          onCardPressed: (puppy) {},
          onFavorite: (puppy, isFavorite) =>
              viewModel.onToggleFavorite(puppy, isFavorite),
        ),
      );
}
