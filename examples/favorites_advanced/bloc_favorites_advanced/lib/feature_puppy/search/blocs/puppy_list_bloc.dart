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
    favoritePuppiesBloc.stream
        .doOnData((_) => print('Subscription FAVORITE'))
        .listen((state) {
      print('Subscription FAVORITE state: $state');
      // add(FavoritePuppiesUpdatedEvent(
      //   favoritePuppies: state.favoritePuppies,
      // ));
    });
  }

  final FavoritePuppiesBloc favoritePuppiesBloc;
  final PuppiesRepository _repository;
  var allPuppies = <Puppy>[];

  late StreamSubscription favoritePuppiesStateSubscription;

  @override
  Future<void> close() {
    favoritePuppiesStateSubscription.cancel();
    print('StateSubscription.cancel()');
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
    print('mapEventToState : ${event.toString()}');
    if (event is LoadPuppyListEvent) {
      yield* _mapPuppiesFetchedToState(state);
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
      yield _mapFavoritePuppiesToState(event.favoritePuppies, state);
    }
  }

  // receive event with 1 puppy with updated isFavorite field
  // merge it in the allPuppies updating it by the id
  // return the PuppyListState(searchedPuppies: allPuppies)
  PuppyListState _mapFavoritePuppiesToState(
      List<Puppy> puppyList, PuppyListState state) {
    // print('MapFavoritePuppiesToState list : $puppyList');

    allPuppies = allPuppies.mergeWith(puppyList);
    return PuppyListState(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.success,
    );
  }

  Future<PuppyListState> _mapPuppyListFetchExtraDetailsEventToState(
      List<Puppy> filteredPuppies, PuppyListState state) async {
    final puppiesWithDetails = await _repository.fetchFullEntities(
        filteredPuppies.map((element) => element.id).toList());

    allPuppies = allPuppies.mergeWith(puppiesWithDetails);

    return state.copyWith(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.success,
    );
  }

  Stream<PuppyListState> _mapPuppiesFetchedToState(
      PuppyListState state) async* {
    // favoritePuppiesStateSubscription =
    //     favoritePuppiesBloc.stream.listen((state) {
    //   print(
    //       'STREAM Subscription: ${state.favoritePuppies}');
    //   add(FavoritePuppiesUpdatedEvent(
    //       favoritePuppies: favoritePuppiesBloc.state.favoritePuppies!));
    // });
    try {
      yield state.copyWith(
        searchedPuppies: [],
        status: PuppyListStatus.initial,
      );
      await Future.delayed(const Duration(milliseconds: 3000));
      final puppies = await _repository.getPuppies(query: '');

      allPuppies = puppies;
      yield state.copyWith(
        searchedPuppies: allPuppies,
        status: PuppyListStatus.success,
      );
    } on Exception {
      yield state.copyWith(
        searchedPuppies: [],
        status: PuppyListStatus.failure,
      );
    }
  }

  Future<PuppyListState> _mapPuppiesReloadFetchToState(
      PuppyListState state) async {
    allPuppies = await _repository.getPuppies(query: '');

    return state.copyWith(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.success,
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
