import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_sample/feature_puppy/list/ui_component/puppy_animated_list_view.dart';
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
            child: PuppyAnimatedListView(
              puppyList: BlocProvider.of<FavoritePuppiesBloc>(context)
                  .state
                  .favoritePuppies,
            ),
          ),
        ],
      );
}

/*
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_sample/feature_puppy/list/ui_component/puppy_animated_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorites_advanced_base/resources.dart';

class FavoritesPage extends StatelessWidget {
  static const favoritesPage = 'Favorites page';

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FavoritePuppiesBloc, FavoritePuppiesState>(
        builder: (context, state) => Column(
          key: const ValueKey(Keys.puppyFavoritesPage),
          children: [
            Expanded(
              child: PuppyAnimatedListView(
                puppyList: state.favoritePuppies,
              ),
            ),
          ],
        ),
      );
}

 */
