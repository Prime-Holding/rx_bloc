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
        .whereType<CoordinatorPuppiesUpdatedState>()
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
      yield _mapFavoritePuppiesToState(event.favoritePuppies, state);
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

  PuppyListState _mapFavoritePuppiesToState(
    List<Puppy> updatedPuppies,
    PuppyListState state,
  ) =>
      state.copyWith(
        status: PuppyListStatus.success,
        searchedPuppies: state.searchedPuppies!.mergeWith(updatedPuppies),
      );

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }
}
