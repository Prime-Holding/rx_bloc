part of 'hotel_list_bloc.dart';

// ignore_for_file: avoid_types_on_closure_parameters

extension _ReloadDataFetcher on Stream<_ReloadData> {
  /// Fetch the hotels based on the [_ReloadData.query]
  ///
  /// In case [_ReloadData.reset] is true, the loading event will be skipped.
  Stream<Result<PaginatedList<Hotel>>> fetchHotels(
    PaginatedHotelsRepository repository,
    BehaviorSubject<PaginatedList<Hotel>> paginatedList,
  ) =>
      switchMap(
        (reloadData) {
          if (reloadData.reset) {
            paginatedList.value.reset(hard: reloadData.fullReset);
          }

          return repository
              .getHotelsPaginated(
                filters: reloadData.filters,
                pageSize: paginatedList.value.pageSize,
                page: paginatedList.value.pageNumber + 1,
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
          list: hotelsToUpdate.value.mergeWith(hotels),
          pageSize: hotelsToUpdate.value.pageSize,
          totalCount: hotelsToUpdate.value.totalCount,
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
    required BehaviorSubject<_FilterByCapacityEventArgs> capacityFilters,
    required BehaviorSubject<SortBy> sort,
    int skipCount = 1,
  }) =>
      skip(skipCount).map(
        (reloadData) => _ReloadData(
          reset: reloadData.reset,
          fullReset: reloadData.fullReset,
          filters: HotelSearchFilters(
            dateRange: dateRange.value,
            query: query.hasValue ? query.value : '',
            roomCapacity: capacityFilters.value.roomCapacity,
            personCapacity: capacityFilters.value.personCapacity,
            sortBy: sort.value,
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
  Stream<HotelSearchFilters> get _filters => Rx.combineLatest4(
      _$filterByQueryEvent.delayInput(),
      _$filterByDateRangeEvent.distinct(),
      _$filterByCapacityEvent.distinct(),
      _$sortByEvent.distinct(),
      (
        String query,
        DateTimeRange? dateRange,
        _FilterByCapacityEventArgs advancedFilters,
        SortBy sortType,
      ) =>
          HotelSearchFilters(
            query: query,
            dateRange: dateRange,
            roomCapacity: advancedFilters.roomCapacity,
            personCapacity: advancedFilters.personCapacity,
            sortBy: sortType,
          ));
}

extension _DateTimeFormatExtensions on DateTime {
  String get _format => DateFormat('dd, MMM').format(this);
}

extension _FilterByAdvancedEventArgsExtensions on _FilterByCapacityEventArgs {
  String get asPresentableText {
    final roomsSelected = roomCapacity > 0;
    final personSelected = personCapacity > 0;

    // If nothing is selected return prematurely
    if (!roomsSelected && !personSelected) return 'None';

    var outputString =
        roomsSelected ? '$roomCapacity Room${roomCapacity > 1 ? 's' : ''}' : '';

    if (personSelected) {
      final separator = roomsSelected ? ' - ' : '';
      final pluralForm = personCapacity > 1 ? 'People' : 'Person';
      outputString += '$separator$personCapacity $pluralForm';
    }

    return outputString;
  }
}

extension _DateRangeEventExtensions on BehaviorSubject<DateTimeRange?> {
  Stream<DateRangeFilterData> getData() => map(
        (range) => DateRangeFilterData(
          dateRange: range,
          text: range != null
              ? '${range.start._format} - ${range.end._format}'
              : 'None',
        ),
      );
}

extension _HotelCapacityEventExtensions
    on BehaviorSubject<_FilterByCapacityEventArgs> {
  Stream<CapacityFilterData> getData() => map(
        (args) => CapacityFilterData(
          rooms: args.roomCapacity,
          persons: args.personCapacity,
          text: args.asPresentableText,
        ),
      );
}

extension _PaginatedListHotelUtils on Stream<PaginatedList<Hotel>> {
  Stream<String> mapToHotelsFound() => map(
        (list) => (list.totalCount ?? 0) > 0
            // ignore: lines_longer_than_80_chars
            ? '${list.totalCount} ${list.totalCount == 1 ? 'hotel' : 'hotels'} found'
            : 'No hotels found',
      );
}
