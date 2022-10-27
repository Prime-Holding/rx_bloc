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

  Future<ManageOperation> getManageOperation(
    IdentifiablePair<ReminderModel> model, [List<ReminderModel>? _]
  ) async {
    final dateRange = _getDateRange();
    if ((model.updatedIdentifiable.dueDate.isAfter(dateRange.from) &&
        model.updatedIdentifiable.dueDate.isBefore(dateRange.to))) {
      return model.updatedIdentifiable.complete
          ? ManageOperation.remove
          : ManageOperation.merge;
    }

    if (model.updatedIdentifiable.dueDate.isBefore(dateRange.from) ||
        model.updatedIdentifiable.dueDate.isAfter(dateRange.to)) {
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
  }) {
    final incrementOperation = _getIncrementOperationFrom(
      managedList: managedList,
    );

    return dashboard.copyWith(
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
    final oldIdentifiable = managedList.identifiablePair.oldIdentifiable;

    final updatedIdentifiable =
        managedList.identifiablePair.updatedIdentifiable;

    if (oldIdentifiable != null &&
        updatedIdentifiable.title == oldIdentifiable.title &&
        updatedIdentifiable.dueDate == oldIdentifiable.dueDate &&
        updatedIdentifiable.complete != oldIdentifiable.complete) {
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
