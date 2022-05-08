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

  Future<ManageOperation> getManageOperation(ReminderModel model) async {
    final dateRange = _getDateRange();

    if (model.dueDate.isAfter(dateRange.from) &&
        model.dueDate.isBefore(dateRange.to)) {
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
  }) =>
      dashboard.copyWith(
        reminderList: managedList.list,
        completeCount: dashboard.recalculateCompleteWith(
          operation: managedList.operation,
          reminderModel: managedList.identifiable,
        ),
        incompleteCount: dashboard.recalculateIncompleteWith(
          operation: managedList.operation,
          reminderModel: managedList.identifiable,
        ),
      );
}

extension _DashboardModelX on DashboardModel {
  int recalculateIncompleteWith({
    required ManageOperation operation,
    required ReminderModel reminderModel,
  }) {
    switch (operation) {
      case ManageOperation.merge:
        return reminderModel.complete ? incompleteCount - 1 : incompleteCount + 1;
      case ManageOperation.remove:
        return reminderModel.complete ? incompleteCount  : incompleteCount - 1;
      case ManageOperation.ignore:
        return incompleteCount;
    }
  }

  int recalculateCompleteWith({
    required ManageOperation operation,
    required ReminderModel reminderModel,
  }) {
    switch (operation) {
      case ManageOperation.merge:
        return reminderModel.complete ? completeCount + 1 : completeCount - 1;
      case ManageOperation.remove:
        return reminderModel.complete ? completeCount - 1 : completeCount;
      case ManageOperation.ignore:
        return completeCount;
    }
  }
}
