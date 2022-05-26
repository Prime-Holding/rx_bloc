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

  Future<ManageOperation> getManageOperation(ReminderModel model, ReminderModel? _) async {
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
    //Todo compare managedList.identifiableInList with managedList.identifiable
    var _identifiableInList = managedList.identifiableInList;
    var _identifiable = managedList.identifiable;
    IncrementOperation? incrementOperation;
    if (_identifiableInList != null &&
        _identifiable.title == _identifiableInList.title &&
        _identifiable.dueDate == _identifiableInList.dueDate &&
        _identifiable.complete != _identifiableInList.complete) {
      if (_identifiable.complete) {
        incrementOperation =
            IncrementOperation.decrementIncompleteIncrementComplete;
      } else {
        incrementOperation =
            IncrementOperation.incrementIncompleteDecrementComplete;
      }
    }

    // if (_identifiableInList == null &&
    //     managedList.counterOperation == CounterOperation.update) {
    //   if (_identifiable.complete) {
        ///mark 0 as complete =ManageOperation.remove, CounterOperation.update ,
        ///identifiable complete = true NOT OK
        // incrementOperation =
        //     IncrementOperation.decrementIncompleteIncrementComplete;
      // } else {
      //   /increment incomplete, decrement complete
        /// mark 91 as incomplete gives - ManageOperation.merge, CounterOperation.update ОК
        // incrementOperation =
        //     IncrementOperation.incrementIncompleteDecrementComplete;
      // }
    // }
    print('incrementOperation: $incrementOperation');
    print('compeleteBefore: ${dashboard.completeCount}');
    print('incompeleteBefore: ${dashboard.incompleteCount}');
    var complete = dashboard.recalculateCompleteWith(
      counterOperation: managedList.counterOperation,
      reminderModel: managedList.identifiable,
      incrementOperation: incrementOperation,
    );
    var inComplete = dashboard.recalculateIncompleteWith(
      counterOperation: managedList.counterOperation,
      reminderModel: managedList.identifiable,
      incrementOperation: incrementOperation,
    );
    print('compeleteAfter: $complete');
    print('incompeleteAfter: $inComplete');
    print('----------------------------');
    return dashboard.copyWith(
      reminderList: managedList.list,
      completeCount: complete,
      incompleteCount: inComplete,
    );
  }
}

extension _DashboardModelX on DashboardModel {
  int recalculateIncompleteWith({
    required CounterOperation counterOperation,
    required ReminderModel reminderModel,
    IncrementOperation? incrementOperation,
  }) {
    switch (counterOperation) {
      case CounterOperation.create:
        return incompleteCount + 1;
      case CounterOperation.delete:
        return reminderModel.complete ? incompleteCount : incompleteCount - 1;
      case CounterOperation.update:
        if (incrementOperation ==
            IncrementOperation.incrementIncompleteDecrementComplete) {
          return incompleteCount + 1;
        } else if (incrementOperation ==
            IncrementOperation.decrementIncompleteIncrementComplete) {
          return incompleteCount - 1;
        }
        return incompleteCount;
      // return reminderModel.completeUpdated
      //     ? reminderModel.complete
      //         ? incompleteCount - 1
      //         : incompleteCount + 1
      //     : incompleteCount;
    }
  }

  int recalculateCompleteWith({
    required CounterOperation counterOperation,
    required ReminderModel reminderModel,
    IncrementOperation? incrementOperation,
  }) {
    switch (counterOperation) {
      case CounterOperation.create:
        return completeCount;
      case CounterOperation.delete:
        return reminderModel.complete ? completeCount - 1 : completeCount;
      case CounterOperation.update:
        if (incrementOperation ==
            IncrementOperation.decrementIncompleteIncrementComplete) {
          return completeCount + 1;
        } else if (incrementOperation ==
            IncrementOperation.incrementIncompleteDecrementComplete) {
          return completeCount - 1;
        }
        return completeCount;

      // return reminderModel.completeUpdated
      //     ? reminderModel.complete
      //         ? completeCount + 1
      //         : completeCount - 1
      //     : completeCount;
    }
  }
}
