import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:equatable/equatable.dart';

part 'coordinator_event.dart';

part 'coordinator_state.dart';

class CoordinatorBloc extends Bloc<CoordinatorEvent, CoordinatorState> {
  CoordinatorBloc() : super(CoordinatorInitialState());

  @override
  Stream<Transition<CoordinatorEvent, CoordinatorState>> transformEvents(
    Stream<CoordinatorEvent> events,
    TransitionFunction<CoordinatorEvent, CoordinatorState> transitionFn,
  ) =>
      super.transformEvents(
        Rx.merge(
          [
            events,
            events
                .mapToPuppies()
                .map((puppies) => CoordinatorPuppiesUpdatedEvent(puppies))
          ],
        ),
        transitionFn,
      );

  @override
  Stream<CoordinatorState> mapEventToState(
    CoordinatorEvent event,
  ) async* {
    if (event is CoordinatorPuppiesUpdatedEvent) {
      yield CoordinatorPuppiesUpdatedState(event.puppies);
    } else if (event is CoordinatorFavoritePuppyUpdatedEvent) {
      yield CoordinatorFavoritePuppyUpdatedState(
        favoritePuppy: event.favoritePuppy,
        updateException: event.updateException,
      );
    }
  }
}

extension _CoordinatorEventUtils on Stream<CoordinatorEvent> {
  Stream<List<Puppy>> mapToPuppies() => Rx.merge<List<Puppy>>(
        [
          whereType<CoordinatorPuppyUpdatedEvent>()
              .map((event) => [event.puppy]),
          whereType<CoordinatorPuppiesWithExtraDetailsEvent>()
              .map((event) => event.puppies),
        ],
      );
}
