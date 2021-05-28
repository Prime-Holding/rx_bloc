import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:bloc/bloc.dart';
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
        .whereType<CoordinatorFavoritePuppyUpdatedState>()
        .listen((state) => add(FavoritePuppiesMarkAsFavoriteEvent(
            puppy: state.favoritePuppy,
            isFavorite: state.favoritePuppy.isFavorite)))
        .addTo(_compositeSubscription);
  }

  final PuppiesRepository _puppiesRepository;
  final _compositeSubscription = CompositeSubscription();
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<FavoritePuppiesState> mapEventToState(
    FavoritePuppiesEvent event,
  ) async* {
    if (event is FavoritePuppiesFetchEvent) {
      yield* _mapToFavoritePuppies();
    } else if (event is FavoritePuppiesMarkAsFavoriteEvent) {
      yield* _mapToFavoritesPuppies(event);
    }
  }

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
    _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(puppy));

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
      // print('fav bloc state.favoritePuppies: ${state.favoritePuppies}');
    } on Exception catch (e) {
      yield state.copyWith(
        favoritePuppies: state.favoritePuppies
            .manageList(isFavorite: !isFavorite, puppy: puppy),
        error: e.toString(),
      );
      await Future.delayed(const Duration(milliseconds: 200));
      yield state.copyWith(
        favoritePuppies: state.favoritePuppies
            .manageList(isFavorite: isFavorite, puppy: puppy),
      );
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
    } else if (indexWhere((element) => element.id == puppy.id) != -1) {
      // When a favorite puppy is edited, the updated puppy is replaced
      // in the list
      final puppyIndexInCopiedList =
          copiedList.indexWhere((element) => element.id == puppy.id);
      copiedList[puppyIndexInCopiedList] = puppy;
    }
    return copiedList;
  }
}
