import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:bloc/bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_list_event.dart';

part 'puppy_list_state.dart';

// part 'puppy_list_bloc_models.dart';

class PuppyListBloc extends Bloc<PuppyListEvent, PuppyListState> {
  PuppyListBloc(this.repository)
      : super( PuppyListState(
            searchedPuppies: [], status: PuppyListStatus.initial));

  PuppiesRepository repository;
  late var allPuppies = <Puppy>[];
  var lastFetched = <Puppy>[];

  @override
  Stream<Transition<PuppyListEvent, PuppyListState>> transformEvents(
    Stream<PuppyListEvent> events,
    TransitionFunction<PuppyListEvent, PuppyListState> transitionFn,
  ) => super.transformEvents(
        Rx.merge([
          events.doOnData((event) {
            print('-- Events: $event');
          }),
          events.whereType<PuppyFetchExtraDetailsEvent>().mapEventToList()
          .doOnData((event) {
            // use breakpoints
            print('-- PuppyListFetchExtraDetailsEvent: $event');
          }),
        ]).doOnData((event) {
          print('-- Merged Stream: $event');
        }),
        transitionFn);



  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    if (event is LoadPuppyListEvent) {
      yield await _mapPuppiesFetchedToState(state);
    } else if (event is ReloadPuppiesEvent) {
      yield await _mapPuppiesReloadFetchToState();
      await Future.delayed(const Duration(milliseconds: 2000));
    } else if (event is PuppyListFetchExtraDetailsEvent) {
      // await fetchExtraDetails(event.puppy!);
      // await Future.delayed(const Duration(milliseconds: 100));

      yield await _mapPuppyListFetchExtraDetailsEventToState(event.puppyList);
    }
  }

  /// TODO reload
  Future<PuppyListState> _mapPuppiesReloadFetchToState() async {
    // allPuppies = <Puppy>[];
    // lastFetched = <Puppy>[];

    final repository1 =
        PuppiesRepository(ImagePicker(), ConnectivityRepository());
    // testPuppies = await repository1.getPuppies();
    lastFetched = <Puppy>[];
    // allPuppies = testPuppies;
    // print('DISPLAY : ${state.searchedPuppies![0].displayCharacteristics}');
    return state.copyWith(
      searchedPuppies: await repository.getPuppies(),
      status: PuppyListStatus.success,
    );
  }

  var testPuppies = <Puppy>[];

  Future<PuppyListState> _mapPuppyListFetchExtraDetailsEventToState(
      List<Puppy> puppyList) async {
    //puppyList contains the visible puppies on the screen
    // we should fetch the details for them now

    // allPuppies = await repository.getPuppies();
    // allPuppiesTTTEST = await repository.getPuppies();
    for (var i = 0; i < puppyList.length; i++){
      final currentPuppy = puppyList[i];
      if(!lastFetched.any((element) => element.id == currentPuppy.id)){
        lastFetched.add(puppyList[i]);
      }
    }
    // if (!lastFetched.any((element) => element.id == puppy.id)) {
    //   lastFetched.add(puppy);
    // }

    final filterPuppies =
        lastFetched.where((puppy) => !puppy.hasExtraDetails()).toList();

    if (filterPuppies.isEmpty) {
      // if lastFetched contains only puppies with fetched extra details
      return state.copyWith(
        searchedPuppies: allPuppies,
        status: PuppyListStatus.success,
      );
    }
    final puppiesWithDetails = await repository
        .fetchFullEntities(filterPuppies.map((element) => element.id).toList());

    puppiesWithDetails.forEach((puppyWithDetails) {
      final index =
          allPuppies.indexWhere((puppy) => puppy.id == puppyWithDetails.id);
      allPuppies.replaceRange(index, index + 1, [puppyWithDetails]);
      final indexInLastFetched =
          lastFetched.indexWhere((puppy) => puppy.id == puppyWithDetails.id);
      lastFetched.replaceRange(
          indexInLastFetched, indexInLastFetched + 1, [puppyWithDetails]);
    });

    return state.copyWith(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.success,
    );
  }

  Future<PuppyListState> _mapPuppiesFetchedToState(PuppyListState state) async {
    try {
      if (state.status == PuppyListStatus.initial) {
        // When puppies are loaded for the first time
        // await Future.delayed(const Duration(milliseconds: 2000));
        // final puppiesList = await repository.getPuppies();
        allPuppies = await repository.getPuppies();
        return state.copyWith(
          searchedPuppies: allPuppies,
          status: PuppyListStatus.success,
        );
      }
    } on Exception {
      return state.copyWith(status: PuppyListStatus.failure);
    }
    return state.copyWith(status: PuppyListStatus.failure);
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

//Convert the incoming stream of PuppyListEvent only when the event is
//PuppyFetchExtraDetailsEvent , this event contains a list of puppies
// We get the puppy from each PuppyFetchExtraDetailsEvent and call toList
// on them to return them in the PuppyListFetchExtraDetailsEvent's
// puppyList
extension _PuppyEventToList on Stream<PuppyFetchExtraDetailsEvent> {
  Stream<PuppyListFetchExtraDetailsEvent> mapEventToList() =>
      bufferTime(const Duration(microseconds: 100)).map(
        (puppyFetchList) => PuppyListFetchExtraDetailsEvent(
          // save the list of puppies to the new event and return the event
          puppyList: puppyFetchList
              .cast<PuppyFetchExtraDetailsEvent>()
          //get the puppy from the event
              .map((puppyFetchEvent) => puppyFetchEvent.puppy)
              .whereType<Puppy>()
              .toList(),
        ),
      );
}
