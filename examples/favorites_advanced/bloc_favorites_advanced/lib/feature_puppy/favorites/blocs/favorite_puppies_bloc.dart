import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
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
  FavoritePuppiesBloc({
    required PuppiesRepository puppiesRepository,
    required CoordinatorBloc coordinatorBloc,
  })   : _coordinatorBloc = coordinatorBloc,
        _puppiesRepository = puppiesRepository,
        super(const FavoritePuppiesState(favoritePuppies: []));

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    if (event is FavoritePuppiesFetchEvent) {
      yield await _mapToFavoritePuppies();
    } else if (event is FavoritePuppiesMarkAsFavoriteEvent) {
      yield* _mapToFavoritesPuppies(event);
    }
  }

  ///TODO: handle loading and errors
  Future<FavoritePuppiesState> _mapToFavoritePuppies() async => state.copyWith(
        favoritePuppies: await _puppiesRepository.getFavoritePuppies(),
      );

  Stream<FavoritePuppiesState> _mapToFavoritesPuppies(
    FavoritePuppiesMarkAsFavoriteEvent event,
  ) async* {
    final puppy = event.puppy;
    final isFavorite = event.isFavorite;

    /// Emit an event with the copied instance of the entity, so that UI
    /// can update immediately
    final immediateUpdatedPuppy = puppy.copyWith(isFavorite: isFavorite);

    _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(immediateUpdatedPuppy));

    yield state.copyWith(
      favoritePuppies: state.favoritePuppies
          .manageList(isFavorite: isFavorite, puppy: puppy),
    );

    /// Send a request to the API
    try {
      final updatedPuppy = (await _puppiesRepository.favoritePuppy(
        puppy,
        isFavorite: isFavorite,
      ))
          .copyWith(
        breedCharacteristics: puppy.breedCharacteristics,
        displayCharacteristics: puppy.displayCharacteristics,
        displayName: puppy.displayName,
      );

      _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(updatedPuppy));

      yield state.copyWith(
        favoritePuppies: state.favoritePuppies.manageList(
          isFavorite: updatedPuppy.isFavorite,
          puppy: updatedPuppy,
        ),
      );
    } on Exception catch (e) {
      ///TODO: Implement the proper error handling here

      final revertFavoritePuppy = puppy.copyWith(isFavorite: !isFavorite);

      _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(revertFavoritePuppy));
      yield state.copyWith(
        favoritePuppies: state.favoritePuppies
            .manageList(isFavorite: !isFavorite, puppy: puppy),
        error: e.toString(),
      );
      // yield state.copyWith(favoritePuppies: state.favoritePuppies)
    }
  }
}

extension _PuppyListUtils on List<Puppy> {
  List<Puppy> manageList({required isFavorite, required Puppy puppy}) {
    final copiedList = [...this];

    if (!isFavorite) {
      copiedList.removeWhere(
        (element) => element.id == puppy.id,
      );
    } else if (indexWhere((element) => element.id == puppy.id) == -1) {
      copiedList.add(puppy);
    }

    return copiedList;
  }
}
