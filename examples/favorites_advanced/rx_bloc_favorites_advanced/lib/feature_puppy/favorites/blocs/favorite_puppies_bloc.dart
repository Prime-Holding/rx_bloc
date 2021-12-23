import 'dart:async';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../../base/repositories/paginated_puppies_repository.dart';

part 'favorite_puppies_bloc.rxb.g.dart';
part 'favorite_puppies_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class FavoritePuppiesEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoritePuppies({required bool silently});
}

abstract class FavoritePuppiesStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Puppy>>> get favoritePuppies;

  Stream<int> get count;
}

@RxBloc()
class FavoritePuppiesBloc extends $FavoritePuppiesBloc {
  FavoritePuppiesBloc(
    PaginatedPuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
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

  @override
  Stream<Result<List<Puppy>>> get favoritePuppies => _favoritePuppies;

  @override
  Stream<int> _mapToCountState() => _favoritePuppies.mapToCount();

  @override
  void dispose() {
    _favoritePuppies.close();
    super.dispose();
  }
}
