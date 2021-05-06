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
  })
      : _puppiesRepository = puppiesRepository,
        _coordinatorBloc = coordinatorBloc,
        super(const PuppyManageState());

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBloc _coordinatorBloc;

  @override
  Stream<PuppyManageState> mapEventToState(PuppyManageEvent event,) async* {
    if (event is PuppyManageMarkAsFavoriteEvent) {
      yield* _mapToMarkAsFavorite(event);
    }
  }

  Stream<PuppyManageState> _mapToMarkAsFavorite(
      PuppyManageMarkAsFavoriteEvent event) async* {
    final puppy = event.puppy;
    final isFavorite = event.isFavorite;
    // print('MANAGE bloc _mapToMarkAsFavorite $puppy');
    _coordinatorBloc.add(
        CoordinatorFavoritePuppyUpdatedEvent(puppy
        .copyWith(isFavorite: isFavorite)));
    yield state.copyWith(puppy: puppy);
    // try{
    //   await _puppiesRepository.favoritePuppy(puppy, isFavorite: isFavorite);
    // } on Exception catch (e) {
    //   print('_mapToMarkAsFavorite $e');
    //   // _coordinatorBloc.add(
    //   //     CoordinatorPuppyUpdatedEvent(puppy));
    // }
  }
}
