import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_mark_as_favorite_event.dart';

part 'puppy_mark_as_favorite_state.dart';

class PuppyMarkAsFavoriteBloc
    extends Bloc<PuppyManageEvent, PuppyMarkAsFavoriteState> {
  PuppyMarkAsFavoriteBloc({
    required PuppiesRepository puppiesRepository,
    required CoordinatorBloc coordinatorBloc,
  })   : _puppiesRepository = puppiesRepository,
        _coordinatorBloc = coordinatorBloc,
        super(const PuppyMarkAsFavoriteState());

  @override
  Stream<
      Transition<PuppyManageEvent, PuppyMarkAsFavoriteState>> transformEvents(
          Stream<PuppyManageEvent> events,
          TransitionFunction<PuppyManageEvent, PuppyMarkAsFavoriteState>
              transitionFn) =>
      super.transformEvents(
          events
              .doOnData((event) {
                // print('mark as fav transformEvents1 $event');
              })
              .throttleTime(const Duration(milliseconds: 500), leading: true)
              .doOnData((event) {
                // print('mark as fav transformEvents2 $event');
              }),
          transitionFn);

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<PuppyMarkAsFavoriteState> mapEventToState(
    PuppyManageEvent event,
  ) async* {
    if (event is PuppyMarkAsFavoriteEvent) {
      yield* _mapToMarkAsFavorite(event);
    }
  }

  Stream<PuppyMarkAsFavoriteState> _mapToMarkAsFavorite(
      PuppyMarkAsFavoriteEvent event) async* {
    final puppy = event.puppy;
    final isFavorite = event.isFavorite;
    try {
      //Send event to search list and to details page to change
      // the favorite icon immediately
      _coordinatorBloc.add(
          CoordinatorPuppyUpdatedEvent(puppy.copyWith(isFavorite: isFavorite)));

      await _puppiesRepository.favoritePuppy(
        puppy,
        isFavorite: isFavorite,
      );

      _coordinatorBloc.add(CoordinatorFavoritePuppyUpdatedEvent(
        favoritePuppy: puppy.copyWith(isFavorite: isFavorite),
        updateException: '',
      ));
    } on Exception catch (e) {
      _coordinatorBloc.add(CoordinatorFavoritePuppyUpdatedEvent(
          favoritePuppy: puppy.copyWith(isFavorite: !isFavorite),
          updateException: e.toString()));
    }
  }
}
