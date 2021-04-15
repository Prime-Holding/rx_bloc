import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:meta/meta.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rxdart/rxdart.dart';

part 'puppies_extra_details_event.dart';

part 'puppies_extra_details_state.dart';

class PuppiesExtraDetailsBloc
    extends Bloc<PuppiesExtraDetailsEvent, PuppiesExtraDetailsState> {
  PuppiesExtraDetailsBloc({
    required PuppiesRepository repository,
    required CoordinatorBloc coordinatorBloc,
  })   : _coordinatorBloc = coordinatorBloc,
        _repository = repository,
        super(PuppiesExtraDetailsState());

  @override
  Stream<Transition<PuppiesExtraDetailsEvent, PuppiesExtraDetailsState>>
      transformEvents(
    Stream<PuppiesExtraDetailsEvent> events,
    TransitionFunction<PuppiesExtraDetailsEvent, PuppiesExtraDetailsState>
        transitionFn,
  ) =>
          super.transformEvents(
            Rx.merge([
              events,
              events
                  .whereType<FetchPuppyExtraDetailsEvent>()
                  // .doOnData((event) =>
                  //     print('Puppies Extra Details puppy : ${event.puppy}'))
                  .mapEventToList()
            ]),
            transitionFn,
          );

  final PuppiesRepository _repository;
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<PuppiesExtraDetailsState> mapEventToState(
    PuppiesExtraDetailsEvent event,
  ) async* {
    if (event is FetchPuppiesExtraDetailsEvent) {
      // print('Puppies Extra Details : event.puppies.ids :
      // ${event.puppies.ids}');
      try {
        final puppiesWithDetails =
        await _repository.fetchFullEntities(event.puppies.ids);
        _coordinatorBloc.add(
          CoordinatorPuppiesWithExtraDetailsEvent(puppiesWithDetails),
        );
      } on Exception catch (e){
        print('Puppy Extra Details Bloc ${e.toString()}');
      }
    }
  }
}

extension _PuppyEventToList on Stream<FetchPuppyExtraDetailsEvent> {
  Stream<FetchPuppiesExtraDetailsEvent> mapEventToList() =>
      distinct()
      .bufferTime(const Duration(milliseconds: 100))
      .map(
        (puppyFetchList) => FetchPuppiesExtraDetailsEvent(
          /// Save the list of puppies to the new event and return the event
          puppyFetchList
              .map((puppyFetchEvent) => puppyFetchEvent.puppy)
              .whereType<Puppy>()
              .where((puppy) => !puppy.hasExtraDetails())
              .toList()
        ),
      )
      .where((list) => list.puppies.isNotEmpty)
      .distinct();
}
