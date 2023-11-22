import 'package:rx_bloc_list/models.dart';

import '../models/reminder/reminder_model.dart';
import '../repositories/reminders_repository.dart';

/// Reminders service class handling all reminders related operations
class RemindersService {
  /// Reminders service constructor taking in a [RemindersRepository]
  RemindersService(this._repository);

  final RemindersRepository _repository;

  /// Returns all reminders
  Future<PaginatedList<ReminderModel>> getAll(ReminderModelRequest request) =>
      _repository.getAll(request);

  /// Returns all reminders for the dashboard
  Future<PaginatedList<ReminderModel>> getAllDashboard(
          ReminderModelRequest request) =>
      _repository.getAllDashboard(request);

  /// Creates a new reminder
  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) =>
      _repository.create(
        title: title,
        dueDate: dueDate,
        complete: complete,
      );

  /// Deletes a reminder with the provided [id]
  Future<void> delete(String id) => _repository.delete(id);

  /// Updates an existing reminder
  Future<ReminderPair> update(ReminderModel model) => _repository.update(model);

  /// Returns the number of complete reminders
  Future<int> getCompleteCount() => _repository.getCompleteCount();

  /// Returns the number of incomplete reminders
  Future<int> getIncompleteCount() => _repository.getIncompleteCount();
}
