import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/models/counter/increment_operation.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  DashboardService(this._remindersService);

  final RemindersService _remindersService;

  Future<PaginatedList<ReminderModel>> getDashboardPaginated(
      BehaviorSubject<PaginatedList<ReminderModel>> paginatedList) async {
    final request = ReminderModelRequest(
      page: paginatedList.value.pageNumber + 1,
      pageSize: paginatedList.value.pageSize,
      sort: ReminderModelRequestSort.dueDateDesc,
      filterByDueDateRange: _getDateRange(),
      complete: false,
    );

    final list = await _remindersService.getAllDashboard(request);
    return list;
  }

  Future<DashboardModel> getDashboardModel() async {
    final data = await Future.wait([
      _remindersService.getCompleteCount(),
      _remindersService.getIncompleteCount(),
    ]);

    final completeCount = data[0];
    final incompleteCount = data[1];

    return DashboardModel(
      incompleteCount: incompleteCount,
      completeCount: completeCount,
    );
  }

  Future<ManageOperation> getManageOperation(Identifiable model,
      [List<ReminderModel>? _]) async {
    final dateRange = _getDateRange();
    final reminder = model as ReminderModel;
    if ((reminder.dueDate.isAfter(dateRange.from) &&
        reminder.dueDate.isBefore(dateRange.to))) {
      return reminder.complete ? ManageOperation.remove : ManageOperation.merge;
    }

    if (reminder.dueDate.isBefore(dateRange.from) ||
        reminder.dueDate.isAfter(dateRange.to)) {
      return ManageOperation.remove;
    }
    return ManageOperation.merge;
  }

  DueDateRange _getDateRange() => DueDateRange(
        to: DateTime.now(),
        from: DateTime.now().subtract(const Duration(days: 10)),
      );

  DashboardModel getDashboardModelFromManagedList({
    required DashboardModel dashboard,
    required ManagedList<ReminderModel> managedList,
    required CounterOperation counterOperation,
    ReminderModel? oldReminder,
  }) {
    final incrementOperation = _getIncrementOperationFrom(
      managedList: managedList,
      oldReminder: oldReminder,
    );

    return dashboard.copyWith(
      completeCount: dashboard.recalculateCompleteWith(
        counterOperation: counterOperation,
        reminderModel: managedList.identifiable,
        incrementOperation: incrementOperation,
      ),
      incompleteCount: dashboard.recalculateIncompleteWith(
        counterOperation: counterOperation,
        reminderModel: managedList.identifiable,
        incrementOperation: incrementOperation,
      ),
    );
  }

  IncrementOperation? _getIncrementOperationFrom({
    required ManagedList<ReminderModel> managedList,
    ReminderModel? oldReminder,
  }) {
    final updatedIdentifiable = managedList.identifiable;

    if (updatedIdentifiable.title == oldReminder?.title &&
        updatedIdentifiable.dueDate == oldReminder?.dueDate &&
        updatedIdentifiable.complete != oldReminder?.complete) {
      return updatedIdentifiable.complete
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
