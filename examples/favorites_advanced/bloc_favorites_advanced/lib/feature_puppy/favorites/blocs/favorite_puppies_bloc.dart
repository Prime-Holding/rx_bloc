import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'favorite_puppies_event.dart';

part 'favorite_puppies_state.dart';

class FavoritePuppiesBloc
    extends Bloc<FavoritePuppiesEvent, FavoritePuppiesState> {
  FavoritePuppiesBloc({
    required PuppiesRepository puppiesRepository,
    required CoordinatorBloc coordinatorBloc,
  })   : _coordinatorBloc = coordinatorBloc,
        _puppiesRepository = puppiesRepository,
        super(const FavoritePuppiesState(favoritePuppies: [])) {
    _coordinatorBloc.stream
        .doOnData((event) {
          // print('Puppy List Bloc coordinatorBloc.stream ! $event');
        })
        .whereType<CoordinatorFavoritePuppyUpdatedState>()
        .doOnData((event) {
          // print(
          //     'Favorite Puppies Bloc coordinatorBloc.stream ${
          //         event.favoritePuppy}');
        })
        .listen((state) => add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: state.favoritePuppy,
            isFavorite: state.favoritePuppy.isFavorite)))
        .addTo(_compositeSubscription);
  }

  final PuppiesRepository _puppiesRepository;
  final _compositeSubscription = CompositeSubscription();
  final CoordinatorBloc _coordinatorBloc;
  bool errorDisplayed = false;

  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    if (event is FavoritePuppiesFetchEvent) {
      yield* _mapToFavoritePuppies();
    } else if (event is FavoritePuppiesMarkAsFavoriteEvent) {
      yield* _mapToFavoritesPuppies(event);
    } else if (event is FavoritePuppiesUpdatedEvent) {
      yield* _mapToFavoritePuppiesUpdatedEvent(event.puppies, state);
    }
  }

  Stream<FavoritePuppiesState> _mapToFavoritePuppiesUpdatedEvent(
    List<Puppy> updatedPuppies,
    FavoritePuppiesState state,
  ) async* {
    // print('_mapToFavoritePuppiesUpdatedEvent ${updatedPuppies}');
    // print(
    //     '_mapToFavoritePuppiesUpdatedEvent BEFORE ADD '
    //         '${state.favoritePuppies}');
    // var favoritePuppies = await _puppiesRepository.getFavoritePuppies();
    // favoritePuppies.forEach((puppy) {
    //   state.favoritePuppies = await _puppiesRepository.getFavoritePuppies();
    // });
    // print(
    //     '_mapToFavoritePuppiesUpdatedEvent
    //     AFTER ADD ${state.favoritePuppies}');
    final puppies = await _puppiesRepository.getFavoritePuppies();

    final test = <Puppy>[];
    puppies.forEach((puppy) {
      test.add(puppy.copyWith(
        breedCharacteristics: puppy.breedCharacteristics,
        displayCharacteristics: puppy.displayCharacteristics,
        displayName: puppy.displayName,
      ));
    });

    state.favoritePuppies.mergeWith(test);
    yield state;
    // final updatedPuppy = (await _puppiesRepository.favoritePuppy(
    //   puppy,
    //   isFavorite: isFavorite,
    // ))
    //     .copyWith(
    //   breedCharacteristics: puppy.breedCharacteristics,
    //   displayCharacteristics: puppy.displayCharacteristics,
    //   displayName: puppy.displayName,
    // );

    // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(updatedPuppy));

    // yield state.copyWith(
    //   favoritePuppies: state.favoritePuppies.manageList(
    //     isFavorite: updatedPuppy.isFavorite,
    //     puppy: updatedPuppy,
    //   ),
    // );
  }

  ///TODO: handle loading and errors
  Stream<FavoritePuppiesState> _mapToFavoritePuppies() async* {
    try {
      yield state.copyWith(
        favoritePuppies: await _puppiesRepository.getFavoritePuppies(),
      );
    } on Exception catch (e) {
      yield state.copyWith(
        favoritePuppies: [],
        error: e.toString(),
      );
    }
  }

  Stream<FavoritePuppiesState> _mapToFavoritesPuppies(
    FavoritePuppiesMarkAsFavoriteEvent event,
  ) async* {
    final puppy = event.puppy;
    final isFavorite = event.isFavorite;

    /// Emit an event with the copied instance of the entity, so that UI
    /// can update immediately
    // final immediateUpdatedPuppy = puppy.copyWith(isFavorite: isFavorite);

    // print('Favorite bloc BEFORE adding in coordinator bloc ');
    _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(puppy));
    // yield state.copyWith(
    //   favoritePuppies: state.favoritePuppies.manageList(
    //     puppy: puppy, isFavorite: !puppy.isFavorite,
    //   ),
    // );
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
      errorDisplayed = false;
    } on Exception catch (e) {
      // final revertFavoritePuppy = puppy.copyWith(isFavorite: !isFavorite);

      // _coordinatorBloc.add(
      // CoordinatorPuppyUpdatedEvent(revertFavoritePuppy));

      // if (errorDisplayed == false) {
        yield state.copyWith(
          favoritePuppies: state.favoritePuppies
              .manageList(isFavorite: !isFavorite, puppy: puppy),
          error: e.toString(),
        );
        await Future.delayed(const Duration(milliseconds: 200));
        // errorDisplayed = true;
      // }
      yield state.copyWith(
        favoritePuppies: state.favoritePuppies
            .manageList(isFavorite: isFavorite, puppy: puppy),
      );
      // print(
      //     'Favorite bloc state.listLength: ${
      //         state.favoritePuppies.length}');
      //
      // yield state.copyWith(
      //   favoritePuppies: state.favoritePuppies
      //       .manageList(isFavorite: !isFavorite, puppy: puppy),
      // );
      // print('Favorite bloc state.favoritePuppies.length: ${
      //     state.favoritePuppies.length}');
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
