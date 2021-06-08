import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:favorites_advanced_base/core.dart';

import 'package:bloc/bloc.dart';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_details_event.dart';

part 'puppy_details_state.dart';

class PuppyDetailsBloc extends Bloc<PuppyDetailsEvent, PuppyDetailsState> {
  PuppyDetailsBloc({
    required CoordinatorBloc coordinatorBloc,
    required Puppy puppy,
  })   : _coordinatorBloc = coordinatorBloc,
        super(PuppyDetailsState(puppy: puppy)) {
    _coordinatorBloc.stream
        .whereType<CoordinatorFavoritePuppyUpdatedState>()
        .listen((state) => add(PuppyDetailsFavoriteEvent(
              puppy: state.favoritePuppy,
              updateException: state.updateException,
            )))
        .addTo(_compositeSubscription);

    _coordinatorBloc.stream
        .whereType<CoordinatorPuppiesUpdatedState>()
        .listen((state) => add(PuppyDetailsMarkAsFavoriteEvent(
              puppies: state.puppies,
            )))
        .addTo(_compositeSubscription);
  }

  @override
  Stream<Transition<PuppyDetailsEvent, PuppyDetailsState>> transformTransitions(
    Stream<Transition<PuppyDetailsEvent, PuppyDetailsState>> transitions,
  ) =>
      transitions.interval(const Duration(milliseconds: 200));

  final CoordinatorBloc _coordinatorBloc;
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<PuppyDetailsState> mapEventToState(
    PuppyDetailsEvent event,
  ) async* {
    if (event is PuppyDetailsFavoriteEvent) {
      yield* _mapToDetailsFavoriteEvent(event);
    } else if (event is PuppyDetailsMarkAsFavoriteEvent) {
      yield* _mapToDetailsMarkAsFavoriteEvent(event);
    }
  }

  Stream<PuppyDetailsState> _mapToDetailsMarkAsFavoriteEvent(
      PuppyDetailsMarkAsFavoriteEvent event) async* {
    // Update Ui immediately
    yield state.copyWith(puppy: event.puppies[0]);
  }

  Stream<PuppyDetailsState> _mapToDetailsFavoriteEvent(
      PuppyDetailsFavoriteEvent event) async* {
    final puppy = event.puppy;
    if (event.updateException.isEmpty) {
      final copiedPuppy = puppy.copyWith(
          name: puppy.name,
          breedType: puppy.breedType,
          isFavorite: puppy.isFavorite,
          gender: puppy.gender,
          displayCharacteristics: puppy.displayCharacteristics);
      final copiedState = state.copyWith(puppy: copiedPuppy);
      // await Future.delayed(const Duration(milliseconds: 200));
      yield copiedState;
      // await Future.delayed(const Duration(milliseconds: 200));
    } else {
      yield state.copyWith(puppy: puppy.copyWith(isFavorite: puppy.isFavorite));
    }
  }

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }
}
