import 'dart:async';

import 'package:bloc_battle_base/models.dart';
import 'package:bloc_battle_base/repositories.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'favorite_puppies_bloc.rxb.g.dart';
part 'favorite_puppies_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class FavoritePuppiesEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoritePuppies({bool silently});
}

abstract class FavoritePuppiesStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Puppy>>> get favoritePuppies;

  Stream<int> get count;
}

@RxBloc()
class FavoritePuppiesBloc extends $FavoritePuppiesBloc {
  FavoritePuppiesBloc(
      PuppiesRepository repository, CoordinatorBlocType coordinatorBloc) {
    _$reloadFavoritePuppiesEvent
        .fetchPuppies(repository)
        .bind(_favoritePuppies)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onPuppiesUpdated
        .updateFavoritePuppies(_favoritePuppies)
        .disposedBy(_compositeSubscription);
  }

  // MARK: - Subjects
  final _favoritePuppies =
      BehaviorSubject.seeded(Result<List<Puppy>>.success([]));

  // MARK: - Memory management
  final _compositeSubscription = CompositeSubscription();

  @override
  Stream<Result<List<Puppy>>> get favoritePuppies => _favoritePuppies;

  @override
  Stream<int> _mapToCountState() => _favoritePuppies.mapToCount();

  @override
  void dispose() {
    _favoritePuppies.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
