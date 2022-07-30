part of 'paginated_list.dart';

/// PaginatedList binder extensions
extension PaginatedListBinder<T> on Stream<Result<PaginatedList<T>>> {
  /// Convenience method that maps the data from the paginated list to a stream,
  /// handling error, loading and success states
  Stream<PaginatedList<T>> mergeWithPaginatedList(
    BehaviorSubject<PaginatedList<T>> paginatedList,
  ) =>
      map<PaginatedList<T>>((result) {
        // Get the current paginated list data
        final subjectValue = paginatedList.hasValue
            ? paginatedList.value
            : PaginatedList<T>(
                list: [],
                pageSize: 0,
                isLoading: false,
              );

        // If the data is still being fetched/loading, respond with isLoading as true
        if (result is ResultLoading<PaginatedList<T>>) {
          if (subjectValue._backupList.isNotEmpty) {
            return subjectValue.copyWith(
              isLoading: true,
              list: subjectValue._backupList,
            );
          }

          return subjectValue.copyWith(
            isLoading: true,
            isInitialized: false,
          );
        }

        // If an error occurred, pass this error down and mark loading as false
        if (result is ResultError<PaginatedList<T>>) {
          subjectValue._backupList.clear();
          return subjectValue.copyWith(
            isLoading: false,
            isInitialized: false,
            error: result.error,
            list: [],
          );
        }

        // If we got the resulting data successfully, merge and return it
        if (result is ResultSuccess<PaginatedList<T>>) {
          // Have we previously reset data. If yes clear the temporary data
          final isReset = subjectValue._backupList.isNotEmpty;
          final listData = isReset
              ? <T>[...result.data.list]
              : <T>[
                  ...subjectValue.list,
                  ...result.data.list,
                ];
          if (isReset) {
            subjectValue.length = 0;
            subjectValue._backupList.clear();
          }

          return subjectValue.copyWith(
            totalCount: result.data.totalCount,
            pageSize: result.data.pageSize,
            list: listData,
            isLoading: false,
            isInitialized: true,
          );
        }

        return subjectValue;
      }).distinct();
}

/// PaginatedList stream extensions
extension PaginatedListStreamExtensions<T> on Stream<PaginatedList<T>> {
  /// Awaited value of this method will return once the data has been loaded or
  /// refreshed.
  Future<void> waitToLoad() async {
    await firstWhere((list) => list.isLoading);
    await firstWhere((list) => !list.isLoading);
  }
}

/// PaginatedList snapshot extensions
extension PaginatedListSnapshotExt<T> on AsyncSnapshot<PaginatedList<T>> {
  /// Is this the initial loading of the snapshot data
  bool get isInitialLoading => !hasData || (hasData && data!.isInitialLoading);

  /// Is the next page loading
  bool get isNextPageLoading =>
      !hasData || (hasData && data!.isNextPageLoading);

  /// Is the data loading
  bool get isLoading => !hasData || (hasData && data!.isLoading);

  /// Is the [data] an [error]
  bool get hasPageError => hasData && data!.error != null;

  /// Returns the element of the snapshot or null (if element outside range),
  /// assuming the snapshot data exists.
  T? getItem(int index) => data!.getItem(index);

  /// Returns the number of items from the snapshot, assuming the data exists.
  int get itemCount => data!.itemCount;

  /// Returns the current page number, assuming the data exists.
  int get pageNumber => data!.pageNumber;
}
