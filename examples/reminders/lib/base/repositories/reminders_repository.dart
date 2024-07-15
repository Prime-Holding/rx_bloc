import 'package:rx_bloc_list/models.dart';

import '../data_sources/remote/reminders_data_source.dart';
import '../models/reminder/reminder_model.dart';

/// Repository handling all the reminders related (CRUD) operations
class RemindersRepository {
  /// Constructor taking in a [RemindersDataSource] as a data source
  RemindersRepository({required RemindersDataSource dataSource})
      : _dataSource = dataSource;

  final RemindersDataSource _dataSource;

  /// Returns a list of all reminders from the given data source
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

  /// Returns a list of all reminders for the dashboard from the given
  /// data source
  Future<PaginatedList<ReminderModel>> getAllDashboard(
    ReminderModelRequest? request,
  ) async {
    final response = await _dataSource.getAllDashboard(request);

    return PaginatedList(
      list: response.items,
      pageSize: request?.pageSize ?? 0,
    );
  }

  /// Creates a fresh reminder and returns it
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

  /// Deletes a reminder by its id
  Future<void> delete(String id) => _dataSource.delete(id);

  /// Updates an existing reminder
  Future<ReminderPair> update(ReminderModel model) => _dataSource.update(model);

  /// Returns the number of completed reminders
  Future<int> getCompleteCount() async {
    final completeCount = await _dataSource.getCompleteCount();
    return int.parse(completeCount);
  }

  /// Returns the number of incomplete reminders
  Future<int> getIncompleteCount() async {
    final incompleteCount = await _dataSource.getIncompleteCount();
    return int.parse(incompleteCount);
  }
}
