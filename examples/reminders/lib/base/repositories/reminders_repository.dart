import '../data_sources/local/reminders_local_data_source.dart';
import '../models/reminder_model.dart';

class RemindersRepository {
  RemindersRepository(this._dataSource);

  final RemindersLocalDataSource _dataSource;

  Future<List<ReminderModel>> getAll(ReminderModelRequest? request) =>
      _dataSource.getAll(request);

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

  Future<ReminderModel> update(ReminderModel model) =>
      _dataSource.update(model);

  Future<int> getCompleteCount() => _dataSource.getCompleteCount();

  Future<int> getIncompleteCount() => _dataSource.getIncompleteCount();
}
