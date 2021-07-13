import 'dart:async';

import 'package:booking_app/base/repositories/hotels_repository.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'favorite_hotels_bloc.rxb.g.dart';
part 'favorite_hotels_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class FavoriteHotelsEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoriteHotels({required bool silently});
}

abstract class FavoriteHotelsStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Hotel>>> get favoriteHotels;

  Stream<int> get count;
}

@RxBloc()
class FavoriteHotelsBloc extends $FavoriteHotelsBloc {
  FavoriteHotelsBloc(
    PaginatedHotelsRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    _$reloadFavoriteHotelsEvent
        .fetchHotels(repository)
        .bind(_favoriteHotels)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onHotelsUpdated
        .updateFavoriteHotels(_favoriteHotels)
        .disposedBy(_compositeSubscription);
  }

  // MARK: - Subjects
  final _favoriteHotels =
      BehaviorSubject.seeded(Result<List<Hotel>>.success([]));

  @override
  Stream<Result<List<Hotel>>> get favoriteHotels => _favoriteHotels;

  @override
  Stream<int> _mapToCountState() => _favoriteHotels.mapToCount();

  @override
  void dispose() {
    _favoriteHotels.close();
    super.dispose();
  }
}
