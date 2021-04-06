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
    required BehaviorSubject<_FilterByCapacityEventArgs> advancedFilters,
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
      _$filterByCapacityEvent.distinct(),
      (
        String query,
        DateTimeRange? dateRange,
        _FilterByCapacityEventArgs advancedFilters,
      ) =>
          HotelSearchFilters(
            query: query,
            dateRange: dateRange,
            roomCapacity: advancedFilters.roomCapacity,
            personCapacity: advancedFilters.personCapacity,
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

extension _StreamHotelPaginatedList on Stream<PaginatedList<Hotel>> {
  Stream<PaginatedList<Hotel>> sortBy(BehaviorSubject<SortBy> sortEvent) =>
      withLatestFrom(
          sortEvent,
          (PaginatedList<Hotel> data, SortBy sortingType) =>
              data.copyWith(list: data.list.sortBy(sortingType)));
}

extension _PaginatedListOfHotelsExtensions on List<Hotel> {
  List<Hotel> sortBy(SortBy sortType) {
    // Sort by price
    if (sortType == SortBy.priceAsc || sortType == SortBy.priceDesc) {
      final desc = sortType == SortBy.priceDesc;
      sort(
        (h1, h2) => desc
            ? h1.perNight.compareTo(h2.perNight)
            : h2.perNight.compareTo(h1.perNight),
      );
    }

    // Sort by distance
    if (sortType == SortBy.distanceAsc || sortType == SortBy.distanceDesc) {
      final desc = sortType == SortBy.distanceDesc;
      sort(
        (h1, h2) =>
            desc ? h1.dist.compareTo(h2.dist) : h2.dist.compareTo(h1.dist),
      );
    }

    return this;
  }
}
