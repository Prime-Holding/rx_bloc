import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';

class FavoritesPage extends StatelessWidget {
  static const favoritesPage = 'Favorites page';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FavoritePuppiesBloc, FavoritePuppiesState>(
        key: const ValueKey(Keys.puppyFavoritesPage),
        builder: (context, state) {
          if(state is FavoritePuppiesListState) {
            return Center(
              child: Text(
                state.favoritePuppies.length.toString(),
              ),
            );
          }
          return const Center(
            child: Text(
              'Empty favorites list',
            ),
          );
        }
      );
}
