part of 'paginated_list.dart';

extension PaginatedListBinder<T> on Stream<Result<PaginatedList<T>>> {
  Stream<PaginatedList<T>> mergeWithPaginatedList(
    BehaviorSubject<PaginatedList<T>> paginatedList,
  ) =>
      map<PaginatedList<T>>((result) {
        final subjectValue = paginatedList.value ??
            PaginatedList(
              list: [],
              pageSize: 0,
              isLoading: false,
            );

        if (result is ResultLoading<PaginatedList<T>>) {
          return subjectValue.copyWith(isLoading: true);
        }

        if (result is ResultError<PaginatedList<T>>) {
          return subjectValue.copyWith(isLoading: false, error: result.error);
        }

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
