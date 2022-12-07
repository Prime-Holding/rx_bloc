import 'dart:async';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/repositories.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../../base/repositories/paginated_hotels_repository.dart';

part 'hotel_favorites_bloc.rxb.g.dart';
part 'hotel_favorites_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class HotelFavoritesBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: false)
  void reloadFavoriteHotels({required bool silently});
}

abstract class HotelFavoritesBlocStates {
  @RxBlocIgnoreState()
  Stream<Result<List<Hotel>>> get favoriteHotels;

  Stream<int> get count;
}

@RxBloc()
class HotelFavoritesBloc extends $HotelFavoritesBloc {
  HotelFavoritesBloc(
    PaginatedHotelsRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    _$reloadFavoriteHotelsEvent
        .fetchHotels(repository)
        .bind(_favoriteHotels)
        .addTo(_compositeSubscription);

    coordinatorBloc.states.onHotelsUpdated
        .updateFavoriteHotels(_favoriteHotels)
        .addTo(_compositeSubscription);
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
