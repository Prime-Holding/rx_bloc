import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
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
  PuppyListBloc({
    required PuppiesRepository repository,
    required CoordinatorBloc coordinatorBloc,
  })   : _repository = repository,
        super(PuppyListState.withInitial()) {
    coordinatorBloc.stream
        .doOnData((event) {
          // print('Puppy List Bloc coordinatorBloc.stream ! $event');
        })
        .whereType<CoordinatorPuppiesUpdatedState>()
        .doOnData((event) {
          // print('Puppy List Bloc coordinatorBloc.stream ${event.puppies}');
        })
        .listen((state) =>
            add(FavoritePuppiesUpdatedEvent(favoritePuppies: state.puppies)))
        .addTo(_compositeSubscription);

    add(LoadPuppyListEvent());
  }

  final PuppiesRepository _repository;
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<PuppyListState> mapEventToState(
    PuppyListEvent event,
  ) async* {
    if (event is LoadPuppyListEvent) {
      yield* _mapPuppiesFetchedToState(state);
    } else if (event is ReloadPuppiesEvent) {
      yield* _mapPuppiesFetchedToState(
        state,
        loadStatus: PuppyListStatus.reloading,
      );
    } else if (event is FavoritePuppiesUpdatedEvent) {
      yield* _mapFavoritePuppiesToState(event.favoritePuppies, state);
    } else if (event is PuppyListFilterEvent) {
      yield* _mapPuppiesFilteredToState(event.query, state);
    }
  }

  //TODO
  Stream<PuppyListState> _mapPuppiesFilteredToState(
      String query, PuppyListState state) async* {
    try {
      // First yield PuppyListStatus.initial to display LoadingWidget
      yield state.copyWith(status: PuppyListStatus.initial);

      // Then yield the resulting list
      yield state.copyWith(
        searchedPuppies: await _repository.getPuppies(query: query),
        status: PuppyListStatus.success,
      );
    } on Exception {
      // print('Filter puppies fetch exception');
      yield state.copyWith(status: PuppyListStatus.failure);
    }
  }

  Stream<PuppyListState> _mapPuppiesFetchedToState(
    PuppyListState state, {
    loadStatus = PuppyListStatus.initial,
  }) async* {
    try {
      yield state.copyWith(status: loadStatus);

      yield state.copyWith(
        searchedPuppies: await _repository.getPuppies(query: ''),
        status: PuppyListStatus.success,
      );
    } on Exception {
      yield state.copyWith(status: PuppyListStatus.failure);
    }
  }

  Stream<PuppyListState> _mapFavoritePuppiesToState(
    List<Puppy> updatedPuppies,
    PuppyListState state,
  ) async* {
    // print('Puppy List Bloc _mapFavoritePuppiesToState : $updatedPuppies');
    yield state.copyWith(
      status: PuppyListStatus.success,
      searchedPuppies: state.searchedPuppies!.mergeWith(updatedPuppies),
    );
  }

  @override
  Future<void> close() {
    // print('close');
    _compositeSubscription.dispose();
    return super.close();
  }
}
