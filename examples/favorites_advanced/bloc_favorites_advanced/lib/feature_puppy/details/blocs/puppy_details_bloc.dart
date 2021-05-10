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
    Puppy? puppy,
  })  : _coordinatorBloc = coordinatorBloc,
        _puppy = puppy,
        super(PuppyDetailsState()) {
    _coordinatorBloc.stream
        .doOnData((event) {
          // print('Puppy List Bloc coordinatorBloc.stream ! $event');
        })
        .whereType<CoordinatorFavoritePuppyUpdatedState>()
        .doOnData((event) {
          print(
              'Puppies Details Bloc coordinatorBloc.stream ${
                  event.favoritePuppy}');
        })
        .listen((state) => add(PuppyDetailsEvent(
              puppy: state.favoritePuppy,
              updateException: state.updateException,
            )))
        .addTo(_compositeSubscription);
  }

  final CoordinatorBloc _coordinatorBloc;
  late final Puppy? _puppy; //comes from the search or favorites pages
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<PuppyDetailsState> mapEventToState(
    PuppyDetailsEvent event,
  ) async* {
    final puppy = event.puppy;
    // print('mapEventToState');
    // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(_puppy!));
    print('Puppy Details puppy: $puppy');
    print('Puppy Details event.updateException: ${event.updateException}');
    if(event.updateException == '') {
      // state.puppy = _puppy!.copyWith(isFavorite: !_puppy!.isFavorite);
      state.puppy = null;
      yield state;
      await Future.delayed(const Duration(seconds: 1));
      state.puppy = _puppy!.copyWith(isFavorite: puppy.isFavorite);
      //PuppyDetailsAppBar rebuilds from this state
      // _puppy = _puppy!.copyWith(isFavorite: !_puppy!.isFavorite);
      // TODO
      // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(puppy.copyWith()));
    }else{
      state.puppy = puppy.copyWith(isFavorite: !puppy.isFavorite);

      yield state;
      await Future.delayed(const Duration(seconds: 1));

      state.puppy = puppy.copyWith(isFavorite: puppy.isFavorite);
    }
    // state.puppy = puppy.copyWith(isFavorite: !puppy.isFavorite);

    // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(puppy));
    yield state;
    // yield state.copyWith(puppy: puppy);
  }

  @override
  Future<void> close() {
    // print('close');
    _compositeSubscription.dispose();
    return super.close();
  }
}
