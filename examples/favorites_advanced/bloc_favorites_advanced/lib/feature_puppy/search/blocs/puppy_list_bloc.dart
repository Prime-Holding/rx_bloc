import 'dart:async';
import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:bloc/bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_list_event.dart';

part 'puppy_list_state.dart';

class PuppyListBloc extends Bloc<PuppyListEvent, PuppyListState> {
  PuppyListBloc(this._repository, this.favoritePuppiesBloc)
      : super(const PuppyListState(
          searchedPuppies: [],
          status: PuppyListStatus.initial,
        )) {
    favoritePuppiesStateSubscription =
        favoritePuppiesBloc.stream.listen((state) {
      // print('STREAM _favoritePuppiesStateSubscription');
      add(FavoritePuppiesUpdatedEvent(
          favoritePuppies: favoritePuppiesBloc.state.favoritePuppies!));
    });
  }

  final FavoritePuppiesBloc favoritePuppiesBloc;
  final PuppiesRepository _repository;
  var allPuppies = <Puppy>[];

  late StreamSubscription favoritePuppiesStateSubscription;

  @override
  Future<void> close() {
    favoritePuppiesStateSubscription.cancel();
    return super.close();
  }

  @override
  Stream<Transition<PuppyListEvent, PuppyListState>> transformEvents(
    Stream<PuppyListEvent> events,
    TransitionFunction<PuppyListEvent, PuppyListState> transitionFn,
  ) =>
      super.transformEvents(
          Rx.merge([
            events.doOnData((event) {
              // print('-- Events: ${event.props}');
            }),
            events
                .whereType<PuppyFetchExtraDetailsEvent>()
                .mapEventToList()
                .distinct()
                .doOnData((event) {
              // print(
              //     '-- PuppyListFetchExtraDetailsEvent: ${event
              //         .filteredPuppies}');
            }),
          ]).distinct().doOnData((event) {
            // print('-- MERGED stream : ${event.props}');
          }),
          transitionFn);

  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    // print('mapEventToState : ${event.toString()}');
    if (event is LoadPuppyListEvent) {
      yield await _mapPuppiesFetchedToState(state);
    } else if (event is ReloadPuppiesEvent) {
      yield await _mapPuppiesReloadFetchToState(state);
      await Future.delayed(const Duration(milliseconds: 2000));
    } else if (event is PuppyListFetchExtraDetailsEvent) {
      if (event.filteredPuppies.isEmpty) {
        return;
      }
      yield await _mapPuppyListFetchExtraDetailsEventToState(
          event.filteredPuppies, state);
    } else if (event is FavoritePuppiesUpdatedEvent) {
      yield _mapFavoritePuppyToState(event.favoritePuppies, state);
    }
    // _favoritePuppiesBloc.state.favoritePuppies;
  }

  PuppyListState _mapFavoritePuppyToState(
      List<Puppy> puppyList, PuppyListState state) => PuppyListState(
        searchedPuppies: allPuppies, status: PuppyListStatus.success);

  Future<PuppyListState> _mapPuppyListFetchExtraDetailsEventToState(
      List<Puppy> filteredPuppies, PuppyListState state) async {
    final puppiesWithDetails = await _repository.fetchFullEntities(
        filteredPuppies.map((element) => element.id).toList());

    allPuppies = allPuppies.mergeWith(puppiesWithDetails);

    return state.copyWith(
        searchedPuppies: allPuppies, status: PuppyListStatus.success);
  }

  Future<PuppyListState> _mapPuppiesFetchedToState(PuppyListState state) async {
    try {
      final puppies = await _repository.getPuppies(query: '');
      allPuppies = puppies;
      return state.copyWith(
        searchedPuppies: allPuppies,
        status: PuppyListStatus.reloading,
      );
    } on Exception {
      return state.copyWith(status: PuppyListStatus.failure);
    }
  }

  Future<PuppyListState> _mapPuppiesReloadFetchToState(
      PuppyListState state) async {
    allPuppies = await _repository.getPuppies(query: '');

    return state.copyWith(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.reloading,
    );
  }
}

List<Puppy> puppiesTEST = [
  Puppy(
    id: '0',
    name: 'Charlie',
    asset: 'assets/puppie_1.jpeg',
    isFavorite: true,
    gender: Gender.Male,
    breedType: BreedType.GoldenRetriever,
    displayName: 'CHARLIE',
    displayCharacteristics: 'CH CHAR',
  ),
  Puppy(
    id: '1',
    name: 'Max',
    asset: 'assets/puppie_2.jpeg',
    gender: Gender.Male,
    breedType: BreedType.Cavachon,
    displayName: 'MAX',
    displayCharacteristics: 'MAX CHAR',
  ),
];

extension _PuppyEventToList on Stream<PuppyFetchExtraDetailsEvent> {
  Stream<PuppyListFetchExtraDetailsEvent> mapEventToList() =>
// Get puppies only without extra details
      bufferTime(const Duration(microseconds: 100)).map(
        (puppyFetchList) => PuppyListFetchExtraDetailsEvent(
          // Save the list of puppies to the new event and return the event
          filteredPuppies: puppyFetchList
              .map((puppyFetchEvent) => puppyFetchEvent.puppy)
              .whereType<Puppy>()
              .where((puppy) => !puppy.hasExtraDetails())
              .toList(),
        ),
      );
}
