part of 'reminder_list_bloc.dart';

/// Utility extensions for the Stream<bool> streams used within ReminderListBloc
extension ReminderListBlocStreamExtensions on Stream<bool> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<ReminderModel>>> fetchData(
    RemindersService service,
    BehaviorSubject<PaginatedList<ReminderModel>> paginatedList,
  ) =>
      throttleTime(const Duration(milliseconds: 200)).switchMap(
        (reset) {
          if (reset) {
            paginatedList.value.reset();
          }

          return service
              .getAll(ReminderModelRequest(
                page: paginatedList.value.pageNumber + 1,
                pageSize: paginatedList.value.pageSize,
                sort: ReminderModelRequestSort.dueDateDesc,
              ))
              .asResultStream();
        },
      );
}
