import 'dart:async';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/repositories.dart';

import 'package:bloc/bloc.dart';
import 'package:favorites_advanced_base/models.dart';
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
        .listen((state) => add(PuppyListFavoritePuppiesUpdatedEvent(
            favoritePuppies: state.puppies)))
        .addTo(_compositeSubscription);

    add(LoadPuppyListEvent());
  }

  @override
  Stream<Transition<PuppyListEvent, PuppyListState>> transformEvents(
          Stream<PuppyListEvent> events,
          TransitionFunction<PuppyListEvent, PuppyListState> transitionFn) =>
      super.transformEvents(
          Rx.merge([
            events,
            events.whereType<PuppyListFilterEvent>().mapToPayload()
          ]),
          transitionFn);

  final PuppiesRepository _repository;
  final _compositeSubscription = CompositeSubscription();
  var lastSearchedQuery = '';

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
    } else if (event is PuppyListFavoritePuppiesUpdatedEvent) {
      yield* _mapFavoritePuppiesToState(event.favoritePuppies, state);
    } else if (event is PuppyListFilterUpdatedQueryEvent) {
      yield* _mapPuppiesFilteredToState(event.query, state);
    }
  }

  Stream<PuppyListState> _mapPuppiesFilteredToState(
      String query, PuppyListState state) async* {
    try {
      yield state.copyWith(status: PuppyListStatus.initial);
      lastSearchedQuery = query;
      yield state.copyWith(
        searchedPuppies: await _repository.getPuppies(query: query),
        status: PuppyListStatus.success,
      );
    } on Exception {
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
        searchedPuppies: await _repository.getPuppies(query: lastSearchedQuery),
        status: PuppyListStatus.success,
      );
      lastSearchedQuery = '';
    } on Exception {
      yield state.copyWith(status: PuppyListStatus.failure);
    }
  }

  Stream<PuppyListState> _mapFavoritePuppiesToState(
    List<Puppy> updatedPuppies,
    PuppyListState state,
  ) async* {
    yield state.copyWith(
      status: PuppyListStatus.success,
      searchedPuppies: state.searchedPuppies!.mergeWith(updatedPuppies),
    );
  }

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }
}

extension _FilterPuppiesEventExtension on Stream<PuppyListFilterEvent> {
  Stream<PuppyListFilterUpdatedQueryEvent> mapToPayload() => distinct()
      .debounceTime(const Duration(milliseconds: 600))
      .map((newQuery) =>
          PuppyListFilterUpdatedQueryEvent(query: newQuery.query));
}
