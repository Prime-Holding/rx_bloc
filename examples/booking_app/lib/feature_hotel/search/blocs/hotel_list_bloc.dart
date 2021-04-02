import 'dart:async';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../../base/repositories/paginated_hotels_repository.dart';

part 'hotel_list_bloc.rxb.g.dart';
part 'hotel_list_bloc_extensions.dart';
part 'hotel_list_bloc_models.dart';

abstract class HotelListEvents {
  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _FilterEventArgs(query: ''),
  )
  void filter({required String query, DateTimeRange? dateRange});

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _ReloadEventArgs(reset: true, fullReset: false),
  )
  void reload({required bool reset, bool fullReset = false});
}

abstract class HotelListStates {
  @RxBlocIgnoreState()
  Stream<PaginatedList<Hotel>> get searchedHotels;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;

  @RxBlocIgnoreState()
  Stream<String> get query;

  @RxBlocIgnoreState()
  Stream<String> get hotelsFound;
}

@RxBloc()
class HotelListBloc extends $HotelListBloc {
  HotelListBloc(
    PaginatedHotelsRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    Rx.merge([
      _$filterEvent.mapToPayload(),
      _$reloadEvent.mapToPayload(_$filterEvent),
    ])
        .startWith(_ReloadData(reset: true, query: '', fullReset: true))
        .fetchHotels(repository, _hotels)
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_hotels)
        .bind(_hotels)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onHotelsUpdated
        .updateHotels(_hotels)
        .disposedBy(_compositeSubscription);
  }

  @override
  Future<void> get refreshDone async => _hotels.waitToLoad();

  // MARK: - Subjects
  final _hotels = BehaviorSubject<PaginatedList<Hotel>>.seeded(
    PaginatedList(
      pageSize: 10,
      list: [],
    ),
  );

  @override
  Stream<PaginatedList<Hotel>> get searchedHotels => _hotels;

  @override
  void dispose() {
    _hotels.close();
    super.dispose();
  }

  @override
  Stream<String> get query =>
      _$filterEvent.map((filter) => filter.query).shareReplay(maxSize: 1);

  @override
  Stream<String> get hotelsFound => _hotels.map(
        (list) => (list.totalCount ?? 0) > 0
            ? '${list.totalCount} hotels found'
            : 'No hotels found',
      );
}
