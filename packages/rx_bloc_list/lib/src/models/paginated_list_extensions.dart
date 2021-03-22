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
        final subjectValue = paginatedList.value ??
            PaginatedList(
              list: [],
              pageSize: 0,
              isLoading: false,
            );

        // If the data is still being fetched/loading, respond with isLoading as true
        if (result is ResultLoading<PaginatedList<T>>) {
          if (subjectValue._backupList.isNotEmpty)
            return subjectValue.copyWith(
              isLoading: true,
              list: subjectValue._backupList,
            );

          return subjectValue.copyWith(isLoading: true);
        }

        // If an error occurred, pass this error down and mark loading as false
        if (result is ResultError<PaginatedList<T>>) {
          subjectValue._backupList.clear();
          return subjectValue.copyWith(isLoading: false, error: result.error);
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
            error: result.data.error,
          );
        }

        return subjectValue;
      });
}

/// PaginatedList stream extensions
extension PaginatedListExt<T> on Stream<PaginatedList<T>> {
  /// Awaited value of this method will return once the data has been loaded or
  /// refreshed.
  Future<void> waitToLoad() async {
    await firstWhere((list) => list.isLoading);
    await firstWhere((list) => !list.isLoading);
  }
}
