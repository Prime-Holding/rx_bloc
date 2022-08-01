import 'package:rx_bloc_list/models.dart';

import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';

abstract class RemindersDataSource {
  Future<int> getCompleteCount();

  Future<int> getIncompleteCount();

  Future<ReminderListResponse> getAll(ReminderModelRequest? request);

  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  });

  Future<void> delete(String id);

  Future<IdentifiablePair<ReminderModel>> update(ReminderModel updatedModel);
}
