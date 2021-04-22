import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:bloc_sample/feature_puppy/list/ui_component/puppy_animated_list_view.dart';
import 'package:declarative_animated_list/declarative_animated_list.dart';
import 'package:favorites_advanced_base/models.dart';
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
              builder: (context, state) => DeclarativeList<Puppy>(
                items: state.favoritePuppies,
                itemBuilder: (ctx, puppy, index, animation) =>
                    _puppyTile(puppy, animation, ctx),
                removeBuilder: (ctx, puppy, index, animation) =>
                    _puppyTile(puppy, animation, ctx),
              ),
            ),
          ),
        ],
      );

  Widget _puppyTile(
          Puppy puppy, Animation<double> animation, BuildContext context) =>
      SizeTransition(
        sizeFactor: animation,
        child: PuppyCard(
          key: Key('${Keys.puppyCardNamePrefix}${puppy.id}'),
          puppy: puppy,
          onCardPressed: (puppy) {},
          onFavorite: (puppy, isFavorite) =>
              BlocProvider.of<FavoritePuppiesBloc>(context).add(
                  FavoritePuppiesMarkAsFavoriteEvent(
                      puppy: puppy, isFavorite: isFavorite)),
        ),
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
  Widget build(BuildContext context) => Column(
        key: const ValueKey(Keys.puppyFavoritesPage),
        children: [
          Expanded(
            child: PuppyAnimatedListView(
              puppyList: BlocProvider.of<FavoritePuppiesBloc>(context)
                  .state
                  .favoritePuppies,
              onFavorite: (puppy, isFavorite) =>
                  context.read<FavoritePuppiesBloc>().add(
                        FavoritePuppiesMarkAsFavoriteEvent(
                            puppy: puppy, isFavorite: isFavorite),
                      ),
            ),
          ),
        ],
      );
}
 */
