part of 'hotel_list_bloc.dart';

// ignore_for_file: avoid_types_on_closure_parameters

extension _ReloadDataFetcher on Stream<_ReloadData> {
  /// Fetch the hotels based on the [_ReloadData.query]
  ///
  /// In case [_ReloadData.reset] is true, the loading event will be skipped.
  Stream<Result<PaginatedList<Hotel>>> fetchHotels(
    PaginatedHotelsRepository repository,
    BehaviorSubject<PaginatedList<Hotel>> _paginatedList,
  ) =>
      switchMap(
        (reloadData) {
          if (reloadData.reset) {
            _paginatedList.value!.reset(hard: reloadData.fullReset);
          }

          return repository
              .getHotelsPaginated(
                filters: reloadData.filters,
                pageSize: _paginatedList.value!.pageSize,
                page: _paginatedList.value!.pageNumber + 1,
              )
              .asResultStream();
        },
      );
}

extension StreamBindToHotels on Stream<List<Hotel>> {
  /// Update the given [hotelsToUpdate] based on the list of hotels emitted
  /// in the current stream.
  ///
  /// For more information check [ListHotelUtils.mergeWith].
  StreamSubscription<PaginatedList<Hotel>> updateHotels(
    BehaviorSubject<PaginatedList<Hotel>> hotelsToUpdate,
  ) =>
      map(
        (hotels) => PaginatedList(
          list: hotelsToUpdate.value!.mergeWith(hotels),
          pageSize: hotelsToUpdate.value!.pageSize,
          totalCount: hotelsToUpdate.value!.totalCount,
        ),
      ).bind(hotelsToUpdate);
}

extension _HotelSearchFilterStreamExtensions on Stream<HotelSearchFilters> {
  /// Map search filters to a [_ReloadData]
  Stream<_ReloadData> mapToPayload({
    int skipCount = 1,
  }) =>
      skip(skipCount).map(
        (filters) => _ReloadData(
          reset: true,
          fullReset: true,
          filters: filters,
        ),
      );
}

extension _ReloadFavoriteHotelsEventExtensions on Stream<_ReloadEventArgs> {
  /// Map search filters to a [_ReloadData]
  Stream<_ReloadData> mapToPayload({
    required BehaviorSubject<String> query,
    required BehaviorSubject<DateTimeRange?> dateRange,
    required BehaviorSubject<_FilterByAdvancedEventArgs> advancedFilters,
    int skipCount = 1,
  }) =>
      skip(skipCount).map(
        (reloadData) => _ReloadData(
          reset: reloadData.reset,
          fullReset: reloadData.fullReset,
          filters: HotelSearchFilters(
            dateRange: dateRange.value,
            query: query.value ?? '',
            roomCapacity: advancedFilters.value!.roomCapacity,
            personCapacity: advancedFilters.value!.personCapacity,
          ),
        ),
      );
}

extension _StringBehaviourSubjectExtensions on BehaviorSubject<String> {
  Stream<String> delayInput() => distinct().debounceTime(
        const Duration(milliseconds: 600),
      );
}

extension _HotelListEventsUtils on HotelListBloc {
  Stream<HotelSearchFilters> get _filters => Rx.combineLatest3(
      _$filterByQueryEvent.delayInput(),
      _$filterByDateRangeEvent.distinct(),
      _$filterByAdvancedEvent.distinct(),
      (
        String query,
        DateTimeRange? dateRange,
        _FilterByAdvancedEventArgs advancedFilters,
      ) =>
          HotelSearchFilters(
            query: query,
            dateRange: dateRange,
            roomCapacity: advancedFilters.roomCapacity,
            personCapacity: advancedFilters.personCapacity,
          ));
}
