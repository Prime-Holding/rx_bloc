import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'puppy_list_bloc.rxb.g.dart';
part 'puppy_list_bloc_extensions.dart';
part 'puppy_list_bloc_models.dart';

abstract class PuppyListEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void filterPuppies({@required String query});

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoritePuppies({@required bool silently});
}

abstract class PuppyListStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Puppy>>> get searchedPuppies;
}

@RxBloc()
class PuppyListBloc extends $PuppyListBloc {
  PuppyListBloc(
    PuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    _reloadTrigger()
        .fetchPuppies(repository)
        .bind(_puppies)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onPuppiesUpdated
        .updatePuppies(_puppies)
        .disposedBy(_compositeSubscription);
  }

  //MARK: - Memory Management
  final _compositeSubscription = CompositeSubscription();

  // MARK: - Subjects
  final _puppies = BehaviorSubject.seeded(Result<List<Puppy>>.success([]));

  @override
  Stream<Result<List<Puppy>>> get searchedPuppies => _puppies;

  @override
  void dispose() {
    _puppies.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
