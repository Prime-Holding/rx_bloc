part of 'reminder_list_bloc.dart';

/// Utility extensions for the Stream<bool> streams used within ReminderListBloc
extension ReminderListBlocStreamExtensions on Stream<bool> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<ReminderModel>>> fetchData(
    RemindersService _service,
    BehaviorSubject<PaginatedList<ReminderModel>> _paginatedList,
  ) =>
      throttleTime(const Duration(milliseconds: 200)).switchMap(
        (reset) {
          if (reset) {
            _paginatedList.value.reset();
          }

          return _service
              .getAll(ReminderModelRequest(
                page: _paginatedList.value.pageNumber + 1,
                pageSize: _paginatedList.value.pageSize,
                sort: ReminderModelRequestSort.dueDateDesc,
              ))
              .asResultStream();
        },
      );
}
