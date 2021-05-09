import 'dart:async';
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
  })   : _coordinatorBloc = coordinatorBloc,
        _puppy = puppy,
        super( PuppyDetailsState()){
    _coordinatorBloc.stream
        .doOnData((event) {
      // print('Puppy List Bloc coordinatorBloc.stream ! $event');
    })
        .whereType<CoordinatorFavoritePuppyUpdatedEvent>()
        .doOnData((event) {
      print(
          'Puppies Details Bloc coordinatorBloc.stream ${
              event.favoritePuppy}');
    })
        .listen((state) => add(PuppyDetailsEvent(
        puppy: state.favoritePuppy,
        )))
        .addTo(_compositeSubscription);
  }


  final CoordinatorBloc _coordinatorBloc;
   final Puppy? _puppy;
  final _compositeSubscription = CompositeSubscription();


  // This method will not be used, no event will be added
  @override
  Stream<PuppyDetailsState> mapEventToState(
    PuppyDetailsEvent event,
  ) async* {
    // print('mapEventToState');
    // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(_puppy!));
    print('Puppy Details puppy: $_puppy');
    state.puppy = _puppy!.copyWith(isFavorite: !_puppy!.isFavorite);
    yield state;
  }

  @override
  Future<void> close() {
    // print('close');
    _compositeSubscription.dispose();
    return super.close();
  }

}
