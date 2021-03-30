import 'dart:async';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:bloc/bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_list_event.dart';

part 'puppy_list_state.dart';

// part 'puppy_list_bloc_models.dart';

class PuppyListBloc extends Bloc<PuppyListEvent, PuppyListState> {
  PuppyListBloc(this.repository)
      : super(const PuppyListState(
            searchedPuppies: [], status: PuppyListStatus.initial));

  PuppiesRepository repository;
  StreamSubscription? subscription;
  late var allPuppies = <Puppy>[];
  var lastFetched = <Puppy>[];

  @override
  Stream<Transition<PuppyListEvent, PuppyListState>> transformEvents(
    Stream<PuppyListEvent> events,
    TransitionFunction<PuppyListEvent, PuppyListState> transitionFn,
  ) {
    // print('');
    // if(state.searchedPuppies!.isNotEmpty) {
    if (state is PuppyFetchExtraDetailsEvent) {
      subscription = events
          .bufferTime(const Duration(milliseconds: 100))
          .forEach((element) {
        element.forEach((element1) {
          add(element1);
        });
      }) as StreamSubscription?;
    }

    return events.switchMap(transitionFn);
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    if (event is LoadPuppyListEvent) {
      yield await _mapPuppiesFetchedToState(state);
    } else if (event is ReloadPuppiesEvent) {
      yield await _mapPuppiesReloadFetchToState();
      // await Future.delayed(const Duration(milliseconds: 2000));
    } else if (event is PuppyFetchExtraDetailsEvent) {
      // await fetchExtraDetails(event.puppy!);
      // await Future.delayed(const Duration(milliseconds: 100));

      yield await _mapPuppiesFetchExtraDetailsToState(event.puppy!);
    }
  }

  /// TODO reload
  Future<PuppyListState> _mapPuppiesReloadFetchToState() async {
    // allPuppies = <Puppy>[];
    // lastFetched = <Puppy>[];

    // final repository1 = PuppiesRepository(ImagePicker(),
    //     ConnectivityRepository());
    // final testPuppies = await repository1.getPuppies();
    // allPuppies = testPuppies;
    // print('DISPLAY : ${state.searchedPuppies![0].displayCharacteristics}');
    return state.copyWith(
      searchedPuppies: allPuppies,
      status: PuppyListStatus.initial,
    );
  }

  var testPuppies = <Puppy>[];

  Future<PuppyListState> _mapPuppiesFetchExtraDetailsToState(
      Puppy puppy) async {
    // allPuppies = await repository.getPuppies();
    // allPuppiesTTTEST = await repository.getPuppies();

    if (!lastFetched.any((element) => element.id == puppy.id)) {
      lastFetched.add(puppy);
    }

    final filterPuppies =
        lastFetched.where((puppy) => !puppy.hasExtraDetails()).toList();
    final puppiesWithDetails = await repository
        .fetchFullEntities(filterPuppies.map((element) => element.id).toList());

    puppiesWithDetails.forEach((puppyWithDetails) {
      final index =
          allPuppies.indexWhere((puppy) => puppy.id == puppyWithDetails.id);
      allPuppies.replaceRange(index, index + 1, [puppyWithDetails]);
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
