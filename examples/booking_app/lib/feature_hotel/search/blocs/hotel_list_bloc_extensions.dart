part of 'hotel_list_bloc.dart';

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
                filters: HotelSearchFilters(
                  query: reloadData.query,
                  dateRange: reloadData.dateRange,
                ),
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

extension _FilterHotelsEventExtensions on Stream<_FilterEventArgs> {
  /// Map a string to a [_ReloadData]
  Stream<_ReloadData> mapToPayload() => skip(1)
      .distinct()
      .debounceTime(
        const Duration(milliseconds: 600),
      )
      .map(
        (filters) => _ReloadData(
          reset: true,
          fullReset: true,
          query: filters.query,
          dateRange: filters.dateRange,
        ),
      );
}

extension _ReloadFavoriteHotelsEventExtensions on Stream<_ReloadEventArgs> {
  /// Map a string to a [_ReloadData]
  Stream<_ReloadData> mapToPayload(
    BehaviorSubject<_FilterEventArgs> filterHotelsEvent,
  ) =>
      skip(1).map(
        (reloadData) => _ReloadData(
          reset: reloadData.reset,
          fullReset: reloadData.fullReset,
          query: filterHotelsEvent.value?.query ?? '',
          dateRange: filterHotelsEvent.value?.dateRange,
        ),
      );
}
