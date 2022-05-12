import 'package:rx_bloc_list/models.dart';

import '../data_sources/local/reminders_local_data_source.dart';
import '../models/reminder/reminder_model.dart';

class RemindersRepository {
  RemindersRepository(this._dataSource);

  final RemindersLocalDataSource _dataSource;

  Future<PaginatedList<ReminderModel>> getAll(
    ReminderModelRequest? request,
  ) async {
    final response = await _dataSource.getAll(request);

    return PaginatedList(
      list: response.items,
      totalCount: response.totalCount,
      pageSize: request?.pageSize ?? response.totalCount,
    );
  }

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
    required bool completeUpdated,
  }) =>
      _dataSource.create(
        title: title,
        dueDate: dueDate,
        complete: complete,
        completeUpdated: completeUpdated,
      );

  Future<void> delete(String id) => _dataSource.delete(id);

  Future<ReminderModel> update(ReminderModel model) =>
      _dataSource.update(model);

  Future<int> getCompleteCount() => _dataSource.getCompleteCount();

  Future<int> getIncompleteCount() => _dataSource.getIncompleteCount();
}
