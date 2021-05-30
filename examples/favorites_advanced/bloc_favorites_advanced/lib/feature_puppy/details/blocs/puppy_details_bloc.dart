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
        .listen((state) => add(PuppyDetailsEvent(
              puppy: state.favoritePuppy,
              updateException: state.updateException,
            )))
        .addTo(_compositeSubscription);
  }

  final CoordinatorBloc _coordinatorBloc;
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<PuppyDetailsState> mapEventToState(
    PuppyDetailsEvent event,
  ) async* {
    final puppy = event.puppy;
    if (event.updateException.isEmpty) {
      final copiedPuppy = puppy.copyWith(
          name: puppy.name,
          breedType: puppy.breedType,
          isFavorite: puppy.isFavorite,
          gender: puppy.gender,
          displayCharacteristics: puppy.displayCharacteristics);
      final copiedState = state.copyWith(puppy: copiedPuppy);
      yield copiedState;
    } else {
      yield state.copyWith(
          puppy: puppy.copyWith(isFavorite: !puppy.isFavorite));
      await Future.delayed(const Duration(milliseconds: 100));
      yield state.copyWith(puppy: puppy.copyWith(isFavorite: puppy.isFavorite));
    }
  }

  @override
  Future<void> close() {
    _compositeSubscription.dispose();
    return super.close();
  }
}
