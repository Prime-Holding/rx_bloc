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
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void filterByQuery(String query);

  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: null)
  void filterByDateRange({DateTimeRange? dateRange});

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _ReloadEventArgs(reset: true, fullReset: false),
  )
  void reload({required bool reset, bool fullReset = false});
}

abstract class HotelListStates {
  @RxBlocIgnoreState()
  Stream<PaginatedList<Hotel>> get searchedHotels;

  @RxBlocIgnoreState()
  Stream<DateTimeRange?> get dateRangeFilter;

  @RxBlocIgnoreState()
  Stream<String> get queryFilter;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;

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
      _filters.mapToPayload(),
      _$reloadEvent.mapToPayload(
        query: _$filterByQueryEvent,
        dateRange: _$filterByDateRangeEvent,
      )
    ])
        .startWith(_ReloadData.withInitial())
        .fetchHotels(repository, _hotels)
        .mergeWithPaginatedList(_hotels)
        .bind(_hotels)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onHotelsUpdated
        .updateHotels(_hotels)
        .disposedBy(_compositeSubscription);
  }

  // MARK: - Subjects
  final _hotels = BehaviorSubject<PaginatedList<Hotel>>.seeded(
    PaginatedList(
      pageSize: 10,
      list: [],
    ),
  );

  @override
  Future<void> get refreshDone async => _hotels.waitToLoad();

  @override
  Stream<PaginatedList<Hotel>> get searchedHotels => _hotels;

  @override
  Stream<DateTimeRange?> get dateRangeFilter => _$filterByDateRangeEvent;

  @override
  Stream<String> get queryFilter => _$filterByQueryEvent;

  @override
  Stream<String> get hotelsFound => _hotels.map(
        (list) => (list.totalCount ?? 0) > 0
            ? '${list.totalCount} hotels found'
            : 'No hotels found',
      );

  @override
  void dispose() {
    _hotels.close();
    super.dispose();
  }
}
