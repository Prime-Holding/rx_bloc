import 'package:rx_bloc_list/models.dart';

import '../../base/models/reminder/reminder_model.dart';

/// Service providing the logic for managing the list of reminders
class ReminderListService {
  ReminderListService();

  /// Determines whether a newly created reminder should be merged into the
  /// existing list of reminders based on its due date. If the new reminder's
  /// due date is the same as or after the last reminder in the list, it should
  /// be merged; otherwise, it should be ignored. One of the appropriate
  /// operations of type [ManageOperation] is returned.
  Future<ManageOperation> getManageOperation(
      Identifiable createdModel, List<ReminderModel> list) async {
    final lastElementDueDate = list[list.length - 1].dueDate;
    var createdReminderDate = createdModel as ReminderModel;
    if (lastElementDueDate.isAtSameMomentAs(createdReminderDate.dueDate) ||
        lastElementDueDate.isAfter(createdReminderDate.dueDate)) {
      return ManageOperation.merge;
    }
    return ManageOperation.ignore;
  }
}
