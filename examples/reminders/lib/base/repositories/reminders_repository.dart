import 'package:rx_bloc_list/models.dart';

import '../data_sources/remote/reminders_data_source.dart';
import '../models/reminder/reminder_model.dart';

class RemindersRepository {
  RemindersRepository({required RemindersDataSource dataSource})
      : _dataSource = dataSource;

  final RemindersDataSource _dataSource;

  Future<PaginatedList<ReminderModel>> getAll(
    ReminderModelRequest? request,
  ) async {
    final response = await _dataSource.getAll(request);
    return PaginatedList(
      list: response.items,
      totalCount: response.totalCount,
      pageSize: request?.pageSize ?? response.totalCount!,
    );
  }

  Future<PaginatedList<ReminderModel>> getAllDashboard(
    ReminderModelRequest? request,
  ) async {
    final response = await _dataSource.getAllDashboard(request);

    return PaginatedList(
      list: response.items,
      pageSize: request?.pageSize ?? 0,
    );
  }

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) =>
      _dataSource.create(
        title: title,
        dueDate: dueDate,
        complete: complete,
      );

  Future<void> delete(String id) => _dataSource.delete(id);

  Future<IdentifiablePair<ReminderModel>> update(ReminderModel model) =>
      _dataSource.update(model);

  Future<int> getCompleteCount() => _dataSource.getCompleteCount();

  Future<int> getIncompleteCount() => _dataSource.getIncompleteCount();
}
