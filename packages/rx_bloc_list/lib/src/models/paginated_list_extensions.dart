part of 'paginated_list.dart';

/// PaginatedList extensions
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
          return subjectValue.copyWith(isLoading: true);
        }

        // If an error occurred, pass this error down and mark loading as false
        if (result is ResultError<PaginatedList<T>>) {
          return subjectValue.copyWith(isLoading: false, error: result.error);
        }

        // If we got the resulting data successfully, merge and return it
        if (result is ResultSuccess<PaginatedList<T>>) {
          return subjectValue.copyWith(
            totalCount: result.data.totalCount,
            pageSize: result.data.pageSize,
            list: <T>[...subjectValue.list, ...result.data.list],
            isLoading: false,
            error: result.data.error,
          );
        }

        return subjectValue;
      });
}
