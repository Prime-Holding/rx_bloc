part of 'puppy_list_bloc.dart';

extension _ReloadDataFetcher on Stream<_ReloadData> {
  /// Fetch the puppies based on the [_ReloadData.query]
  ///
  /// In case [_ReloadData.reset] is true, the loading event will be skipped.
  Stream<Result<PaginatedList<Puppy>>> fetchPuppies(
    PaginatedPuppiesRepository repository,
    BehaviorSubject<PaginatedList<Puppy>> paginatedList,
  ) =>
      switchMap(
        (reloadData) {
          if (reloadData.reset) {
            paginatedList.value.reset(hard: reloadData.fullReset);
          }

          return repository
              .getPuppiesPaginated(
                query: reloadData.query,
                pageSize: paginatedList.value.pageSize,
                page: paginatedList.value.pageNumber + 1,
              )
              .asResultStream();
        },
      );
}

extension StreamBindToPuppies on Stream<List<Puppy>> {
  /// Update the given [puppiesToUpdate] based on the list of puppies emitted
  /// in the current stream.
  ///
  /// For more information check [ListPuppyUtils.mergeWith].
  StreamSubscription<PaginatedList<Puppy>> updatePuppies(
    BehaviorSubject<PaginatedList<Puppy>> puppiesToUpdate,
  ) =>
      map(
        (puppies) => PaginatedList(
          list: puppiesToUpdate.value.mergeWith(puppies),
          pageSize: puppiesToUpdate.value.pageSize,
        ),
      ).bind(puppiesToUpdate);
}

extension _FilterPuppiesEventExtensions on Stream<String> {
  /// Map a string to a [_ReloadData]
  Stream<_ReloadData> mapToPayload() => skip(1)
      .distinct()
      .debounceTime(
        const Duration(milliseconds: 600),
      )
      .map(
        (query) => _ReloadData(
          reset: true,
          fullReset: true,
          query: query,
        ),
      );
}

extension _ReloadFavoritePuppiesEventExtensions on Stream<_ReloadEventArgs> {
  /// Map a string to a [_ReloadData]
  Stream<_ReloadData> mapToPayload(
    BehaviorSubject<String> filterPuppiesEvent,
  ) =>
      skip(1).map(
        (reloadData) => _ReloadData(
          reset: reloadData.reset,
          fullReset: reloadData.fullReset,
          query: filterPuppiesEvent.hasValue ? filterPuppiesEvent.value : '',
        ),
      );
}
