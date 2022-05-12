import 'package:collection/collection.dart';
import 'package:rx_bloc_list/models.dart';

import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  DashboardService(this._remindersService);

  final RemindersService _remindersService;

  Future<DashboardModel> getDashboardModel() async {
    final data = await Future.wait([
      _remindersService.getCompleteCount(),
      _remindersService.getIncompleteCount(),
      _remindersService.getAll(
        ReminderModelRequest(
          sort: ReminderModelRequestSort.dueDateDesc,
          page: 1,
          pageSize: 5,
          filterByDueDateRange: _getDateRange(),
        ),
      )
    ]);

    final completeCount = data[0] as int;
    final incompleteCount = data[1] as int;
    final overdueReminder = data[2] as List<ReminderModel>;

    return DashboardModel(
      reminderList: overdueReminder,
      incompleteCount: incompleteCount,
      completeCount: completeCount,
    );
  }

  DashboardModel sortedReminderList(DashboardModel dashboardModel) =>
      dashboardModel.copyWith(
        reminderList: dashboardModel.reminderList
            .sorted((a, b) => a.dueDate.compareTo(b.dueDate)),
      );

//todo implement and test this method for creation and deletion from reminders list
//   Future<ManageOperation> getManageOperationForRemindersList(
//       ReminderModel model) async {
//     final dateRange = _getDateRange();
//
//     if (model.dueDate.isAfter(dateRange.from) &&
//         model.dueDate.isBefore(dateRange.to)) {
//       // if (model.complete) {
//       //coming from dashboard, when it is complete, remove it from dashboard
//       // return ManageOperation.remove;
//       // }
//       return ManageOperation.merge;
//     }
//
//     return ManageOperation.remove;
//   }

  Future<ManageOperation> getManageOperation(ReminderModel model) async {
    final dateRange = _getDateRange();

    if (model.dueDate.isAfter(dateRange.from) &&
        model.dueDate.isBefore(dateRange.to)) {
      if (model.complete) {
        return ManageOperation.remove;
      }
      return ManageOperation.merge;
    }

    return ManageOperation.remove;
  }

  DueDateRange _getDateRange() => DueDateRange(
        to: DateTime.now(),
        from: DateTime.now().subtract(const Duration(days: 10)),
      );

  DashboardModel getDashboardModelFromManagedList({
    required DashboardModel dashboard,
    required ManagedList<ReminderModel> managedList,
  }) {
    var complete = dashboard.recalculateCompleteWith(
      operation: managedList.operation,
      counterOperation: managedList.counterOperation,
      reminderModel: managedList.identifiable,
    );
    var incomplete = dashboard.recalculateIncompleteWith(
      operation: managedList.operation,
      counterOperation: managedList.counterOperation,
      reminderModel: managedList.identifiable,
    );

    final _updatedReminderModel = managedList.identifiable.copyWith(completeUpdated: false);
    final _managedList = managedList.copyWith(
      identifiable: _updatedReminderModel,
    );
    return dashboard.copyWith(
      reminderList: _managedList.list as List<ReminderModel>,
      completeCount: complete,
      incompleteCount: incomplete,
    );
  }
}

extension _DashboardModelX on DashboardModel {
  int recalculateIncompleteWith({
    required ManageOperation operation,

    ///TODO remove this
    required CounterOperation counterOperation,
    required ReminderModel reminderModel,
  }) {
    switch (counterOperation) {
      case CounterOperation.create:
        return incompleteCount + 1;

      // return !reminderModel.complete ? incompleteCount + 1 : incompleteCount;//old
      case CounterOperation.delete:
        return reminderModel.complete ? incompleteCount : incompleteCount - 1;
      // return !reminderModel.complete ? incompleteCount - 1 : incompleteCount;//old
      case CounterOperation.update:
        return reminderModel.completeUpdated
            ? reminderModel.complete
                ? incompleteCount - 1
                : incompleteCount + 1
            : incompleteCount;
    }
    // switch (counterOperation) {
    //   case ManageOperation.merge:
    //     return reminderModel.complete
    //         ? incompleteCount - 1
    //         : incompleteCount + 1;
    //   // return !reminderModel.complete ? incompleteCount + 1 : incompleteCount;//old
    //   case ManageOperation.remove:
    //     return reminderModel.complete ? incompleteCount - 1 : incompleteCount - 1;
    //   // return !reminderModel.complete ? incompleteCount - 1 : incompleteCount;//old
    //   case ManageOperation.ignore:
    //     return incompleteCount;
    // }
  }

  int recalculateCompleteWith({
    required ManageOperation operation,
    required CounterOperation counterOperation,
    required ReminderModel reminderModel,
  }) {
    switch (counterOperation) {
      case CounterOperation.create:
        return completeCount;
      // return reminderModel.complete ? completeCount + 1 : completeCount - 1;
      // return reminderModel.complete ? completeCount + 1 : completeCount;//old
      case CounterOperation.delete:
        return reminderModel.complete ? completeCount - 1 : completeCount;
      case CounterOperation.update:
        return reminderModel.completeUpdated
            ? reminderModel.complete
                ? completeCount + 1
                : completeCount - 1
            : completeCount;
    }

    // switch (operation) {
    //   case ManageOperation.merge:
    //     return reminderModel.complete
    //         ? completeCount + 1
    //         : completeCount - 1; //new
    //   return reminderModel.complete ? completeCount + 1 : completeCount - 1;
    //   return reminderModel.complete ? completeCount + 1 : completeCount;//old
    // case ManageOperation.remove:
    //   return reminderModel.complete ? completeCount + 1 : completeCount;
    // case ManageOperation.ignore:
    //   return completeCount;
    // }
  }
}
