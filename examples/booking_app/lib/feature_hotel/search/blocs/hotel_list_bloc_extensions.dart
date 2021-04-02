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
                filters: HotelSearchFilters(
                  query: reloadData.filters.query,
                  dateRange: reloadData.filters.dateRange,
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

extension _HotelSearchFilterStreamExtensions on Stream<HotelSearchFilters> {
  /// Map search filters to a [_ReloadData]
  Stream<_ReloadData> mapToPayload() => skip(1).map(
        (filters) => _ReloadData(
          reset: true,
          fullReset: true,
          filters: filters,
        ),
      );
}

extension _ReloadFavoriteHotelsEventExtensions on Stream<_ReloadEventArgs> {
  /// Map search filters to a [_ReloadData]
  Stream<_ReloadData> mapToPayload(
    Stream<HotelSearchFilters> filtersStream,
  ) =>
      withLatestFrom(
              filtersStream,
              (_ReloadEventArgs reloadData, HotelSearchFilters searchFilters) =>
                  _ReloadData(
                    reset: reloadData.reset,
                    filters: searchFilters,
                  )).skip(1).map(
            (reloadData) => _ReloadData(
              reset: reloadData.reset,
              fullReset: reloadData.fullReset,
              filters: reloadData.filters,
            ),
          );
}

extension _StringBehaviourSubjectExtensions on BehaviorSubject<String> {
  Stream<String> delayInput() => distinct().debounceTime(
        const Duration(milliseconds: 600),
      );
}
