import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:favorites_advanced_base/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';

class FavoritesPage extends StatelessWidget {
  static const favoritesPage = 'Favorites page';

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey(Keys.puppyFavoritesPage),
        children: [
          Expanded(
            child: BlocBuilder<FavoritePuppiesBloc, FavoritePuppiesState>(
              builder: (context, state) => PuppyAnimatedListView(
                puppyList: state.favoritePuppies,
                onFavorite: (puppy, isFavorite) =>
                    BlocProvider.of<FavoritePuppiesBloc>(context).add(
                        FavoritePuppiesMarkAsFavoriteEvent(
                            puppy: puppy, isFavorite: isFavorite)),
              ),
            ),
          ),
        ],
      );
}
