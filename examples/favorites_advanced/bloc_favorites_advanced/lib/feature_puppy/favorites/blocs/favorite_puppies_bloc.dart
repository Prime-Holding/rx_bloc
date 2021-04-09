import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'favorite_puppies_event.dart';

part 'favorite_puppies_state.dart';

class FavoritePuppiesBloc
    extends Bloc<FavoritePuppiesEvent, FavoritePuppiesState> {
  FavoritePuppiesBloc(this.puppiesRepository)
      : super(const FavoritePuppiesListState(favoritePuppies: [])) {
    print('CONSTRUCTOR');
  }

  PuppiesRepository puppiesRepository;
  var favoritePuppies = <Puppy>[];

  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    if (favoritePuppies.isEmpty) {
      await _getInitialFavoritePuppies();
    }
    if (event is MarkAsFavoriteEvent) {
      // yield await _mapToFavoritesPuppies(event);
      yield* _mapToFavoritesPuppies(event);
      // yield test;
      // Check if it is emitting correctly
      // print('Favorite puppies state: ${state.favoritePuppies}');
      yield* _mapToFavoritePuppy(event);
      // yield favoritePuppy;
    }
  }

  @override
  Future<void> close() {
    print('FAVORITES.cancel()');
    return super.close();
  }

  Future<void> _getInitialFavoritePuppies() async {
    favoritePuppies = await puppiesRepository.getFavoritePuppies();
  }

  Stream<FavoritePuppyState> _mapToFavoritePuppy(
      MarkAsFavoriteEvent event) async* {
    final puppy = event.puppy;
    final isFavoriteNew = event.isFavorite;

    yield FavoritePuppyState(
      favoritePuppy: puppy,
      status: FavoritePuppiesStatus.loading,
    );

    yield FavoritePuppyState(
      favoritePuppy: puppy.copyWith(isFavorite: isFavoriteNew),
      status: FavoritePuppiesStatus.success,
    );
    yield FavoritePuppyState(
      favoritePuppy: puppy,
      status: FavoritePuppiesStatus.loading,
    );
    try {
      final updatedPuppy = await puppiesRepository.favoritePuppy(puppy,
          isFavorite: isFavoriteNew);

      yield FavoritePuppyState(
        favoritePuppy: updatedPuppy.copyWith(
          breedCharacteristics: puppy.breedCharacteristics,
          displayCharacteristics: puppy.displayCharacteristics,
          displayName: puppy.displayName,
        ),
        status: FavoritePuppiesStatus.success,
      );
    } on Exception catch (e) {}


  }

  // Add or remove the puppy from the favoritePuppies list
  Stream<FavoritePuppiesListState> _mapToFavoritesPuppies(
          MarkAsFavoriteEvent event) async* {
    final puppy = event.puppy;
    final isFavoriteNew = event.isFavorite;

    if (isFavoriteNew) {
      if (!favoritePuppies.any((element) => element.id == puppy.id)) {
        favoritePuppies.add(puppy);
      }
    } else {
      favoritePuppies.removeWhere((element) => element.id == puppy.id);
    }
    yield FavoritePuppiesListState(favoritePuppies: favoritePuppies);
  }


// Future<FavoritePuppyState> _mapToFavoritePuppy(
//   MarkAsFavoriteEvent event,
// ) async {
//   var puppy = event.puppy;
//
//   return FavoritePuppyState(favoritePuppy: puppy);
// }
}
