import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';

part 'puppy_manage_event.dart';

part 'puppy_manage_state.dart';

class PuppyManageBloc extends Bloc<PuppyManageEvent, PuppyManageState> {
  PuppyManageBloc({
    required PuppiesRepository puppiesRepository,
    required CoordinatorBloc coordinatorBloc,
  })   : _puppiesRepository = puppiesRepository,
        _coordinatorBloc = coordinatorBloc,
        super(const PuppyManageState());

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<PuppyManageState> mapEventToState(
    PuppyManageEvent event,
  ) async* {
    if (event is PuppyManageMarkAsFavoriteEvent) {
      yield* _mapToMarkAsFavorite(event);
    }
  }

  Stream<PuppyManageState> _mapToMarkAsFavorite(
      PuppyManageMarkAsFavoriteEvent event) async* {
    final puppy = event.puppy;
    final isFavorite = event.isFavorite;
    // print('MANAGE bloc _mapToMarkAsFavorite $puppy');
    try {
      ///Send event to search list to change the icon immediately
      _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(
          puppy.copyWith(isFavorite: isFavorite)));

       await _puppiesRepository.favoritePuppy(
        puppy,
        isFavorite: isFavorite,
      );

      _coordinatorBloc
          .add(CoordinatorFavoritePuppyUpdatedEvent(
          favoritePuppy: puppy.copyWith(isFavorite: isFavorite),
      updateException: ''));

      // _coordinatorBloc.add(CoordinatorPuppyUpdatedEvent(updatedPuppy));

      // errorDisplayed = false;
    } on Exception catch (e) {
      // _coordinatorBloc.add(
      //     CoordinatorFavoritePuppyUpdatedEvent(puppy
      //         .copyWith(isFavorite: !isFavorite)));
      final revertFavoritePuppy = puppy.copyWith(isFavorite: !isFavorite);
      _coordinatorBloc
          .add(CoordinatorPuppyUpdatedEvent(revertFavoritePuppy));

      // _coordinatorBloc
      //     .add(CoordinatorPuppyUpdatedEvent(revertFavoritePuppy));
      yield state.copyWith(error: e.toString());
      _coordinatorBloc
          .add(CoordinatorFavoritePuppyUpdatedEvent(favoritePuppy: puppy,
      updateException: e.toString()));
    }
    // yield state.copyWith(puppy: puppy);
  }
}
