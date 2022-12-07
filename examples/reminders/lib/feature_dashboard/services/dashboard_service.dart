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

  Future<DashboardCountersModel> getDashboardModel() async {
    final data = await Future.wait([
      _remindersService.getCompleteCount(),
      _remindersService.getIncompleteCount(),
    ]);

    final completeCount = data[0];
    final incompleteCount = data[1];

    return DashboardCountersModel(
      incompleteCount: incompleteCount,
      completeCount: completeCount,
    );
  }

  Future<ManageOperation> getManageOperation(
      Identifiable model, List<ReminderModel> _) async {
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

  DashboardCountersModel getCountersModelFromCounterOperation({
    required DashboardCountersModel dashboardCounters,
    required CounterOperation counterOperation,
  }) {
    return dashboardCounters.copyWith(
      completeCount: dashboardCounters
          .recalculateCompleteWithCounterOperation(counterOperation),
      incompleteCount: dashboardCounters
          .recalculateIncompleteWithCounterOperation(counterOperation),
    );
  }
}

extension _DashboardModelX on DashboardCountersModel {
  int recalculateIncompleteWithCounterOperation(
    CounterOperation counterOperation,
  ) {
    switch (counterOperation) {
      case CounterOperation.create:
        return incompleteCount + 1;
      case CounterOperation.deleteIncomplete:
        return incompleteCount - 1;
      case CounterOperation.deleteComplete:
        return incompleteCount;
      case CounterOperation.setComplete:
        return incompleteCount - 1;
      case CounterOperation.unsetComplete:
        return incompleteCount + 1;
      case CounterOperation.none:
        return incompleteCount;
    }
  }

  int recalculateCompleteWithCounterOperation(
    CounterOperation counterOperation,
  ) {
    switch (counterOperation) {
      case CounterOperation.create:
        return completeCount;
      case CounterOperation.deleteIncomplete:
        return completeCount;
      case CounterOperation.deleteComplete:
        return completeCount - 1;
      case CounterOperation.setComplete:
        return completeCount + 1;
      case CounterOperation.unsetComplete:
        return completeCount - 1;
      case CounterOperation.none:
        return completeCount;
    }
  }
}
