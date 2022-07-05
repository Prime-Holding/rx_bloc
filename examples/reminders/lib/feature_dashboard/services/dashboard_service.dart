import 'package:collection/collection.dart';
import 'package:rx_bloc_list/models.dart';

import '../../base/models/counter/increment_operation.dart';
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

  Future<ManageOperation> getManageOperation(
    IdentifiablePair<ReminderModel> model,
  ) async {
    final dateRange = _getDateRange();

    if (model.updatedIdentifiable.dueDate.isAfter(dateRange.from) &&
        model.updatedIdentifiable.dueDate.isBefore(dateRange.to)) {
      return model.updatedIdentifiable.complete
          ? ManageOperation.remove
          : ManageOperation.merge;
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
    required CounterOperation counterOperation,
  }) {
    final incrementOperation = _getIncrementOperationFrom(
      managedList: managedList,
    );

    return dashboard.copyWith(
      reminderList: managedList.list,
      completeCount: dashboard.recalculateCompleteWith(
        counterOperation: counterOperation,
        reminderModel: managedList.identifiablePair.updatedIdentifiable,
        incrementOperation: incrementOperation,
      ),
      incompleteCount: dashboard.recalculateIncompleteWith(
        counterOperation: counterOperation,
        reminderModel: managedList.identifiablePair.updatedIdentifiable,
        incrementOperation: incrementOperation,
      ),
    );
  }

  IncrementOperation? _getIncrementOperationFrom({
    required ManagedList<ReminderModel> managedList,
  }) {
    final _oldIdentifiable = managedList.identifiablePair.oldIdentifiable;

    final _updatedIdentifiable =
        managedList.identifiablePair.updatedIdentifiable;

    if (_oldIdentifiable != null &&
        _updatedIdentifiable.title == _oldIdentifiable.title &&
        _updatedIdentifiable.dueDate == _oldIdentifiable.dueDate &&
        _updatedIdentifiable.complete != _oldIdentifiable.complete) {
      return _updatedIdentifiable.complete
          ? IncrementOperation.decrementIncompleteIncrementComplete
          : IncrementOperation.incrementIncompleteDecrementComplete;
    }

    return null;
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
    }
  }
}
