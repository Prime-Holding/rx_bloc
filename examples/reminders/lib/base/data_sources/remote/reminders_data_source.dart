import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';

/// Contract used to define any behaviour related to handling reminders
abstract class RemindersDataSource {
  /// Returns the number of completed reminders
  Future<int> getCompleteCount();

  /// Returns the number of incomplete reminders
  Future<int> getIncompleteCount();

  /// Returns a list of all reminders
  Future<ReminderListResponse> getAll(ReminderModelRequest? request);

  /// Returns a list of all reminders for the dashboard
  Future<ReminderListResponse> getAllDashboard(ReminderModelRequest? request);

  /// Creates a new reminder
  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  });

  /// Deletes a reminder by its id
  Future<void> delete(String id);

  /// Updates an existing reminder
  Future<ReminderPair> update(ReminderModel updatedModel);
}
