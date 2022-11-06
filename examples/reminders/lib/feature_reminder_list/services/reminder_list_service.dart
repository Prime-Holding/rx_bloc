import 'package:rx_bloc_list/models.dart';

import '../../base/models/reminder/reminder_model.dart';

class ReminderListService {
  ReminderListService();

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
