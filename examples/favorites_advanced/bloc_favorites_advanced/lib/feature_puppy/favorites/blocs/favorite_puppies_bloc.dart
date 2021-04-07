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
      : super(const FavoritePuppiesState(favoritePuppies: []));

  PuppiesRepository puppiesRepository;
  var favoritePuppies = <Puppy>[];
  // var favoritePuppy;
  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    if (favoritePuppies.isEmpty) {
      await _getInitialFavoritePuppies();
    }
    if (event is MarkAsFavoriteEvent) {
      yield await _mapToFavoritesPuppies(event);
      // print('Favorite puppies state: ${state.favoritePuppies}');
      // yield await _mapToFavoritePuppy(event);
    }
  }

  // Future<FavoritePuppyState> _mapToFavoritePuppy(
  //   MarkAsFavoriteEvent event,
  // ) async {
  //   var puppy = event.puppy;
  //
  //   return FavoritePuppyState(favoritePuppy: puppy);
  // }

  Future<void> _getInitialFavoritePuppies() async {
    favoritePuppies = await puppiesRepository.getFavoritePuppies();
  }

  Future<FavoritePuppiesState> _mapToFavoritesPuppies(
      MarkAsFavoriteEvent event) async {
    final puppy = event.puppy;
    final isFavoriteNew = event.isFavorite;

    // puppy = puppy.copyWith(isFavorite: isFavoriteNew);
    var updatedPuppy =
        await puppiesRepository.favoritePuppy(puppy, isFavorite: isFavoriteNew);
    updatedPuppy = updatedPuppy.copyWith(
      breedCharacteristics: puppy.breedCharacteristics,
      displayCharacteristics: puppy.displayCharacteristics,
      displayName: puppy.displayName,
    );
    // favoritePuppy = updatedPuppy;
    if (isFavoriteNew) {
      favoritePuppies.add(updatedPuppy);
    } else {
      favoritePuppies.removeWhere((element) => element.id == updatedPuppy.id);
      // favoritePuppies.remove(updatedPuppy);
    }
    return FavoritePuppiesState(favoritePuppies: favoritePuppies);
  }
}
