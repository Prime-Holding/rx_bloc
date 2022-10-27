import 'package:rx_bloc_list/models.dart';

import '../../base/models/reminder/reminder_model.dart';

class ReminderListService {
  ReminderListService();

  Future<ManageOperation> getManageOperation(
      IdentifiablePair<ReminderModel> createdModel,
      [List<ReminderModel>? list]) async {
    final lastElementDueDate = list?[list.length - 1].dueDate;

    final createdReminderDate = createdModel.updatedIdentifiable.dueDate;
    if (lastElementDueDate!.isAtSameMomentAs(createdReminderDate) ||
        lastElementDueDate.isAfter(createdReminderDate)) {
      return ManageOperation.merge;
    }
    return ManageOperation.ignore;
  }
}
