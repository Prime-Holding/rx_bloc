import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/models/counter/increment_operation.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../base/services/reminders_service.dart';
import '../models/dashboard_model.dart';

/// Service used to facilitate managing and fetching dashboard related data
class DashboardService {
  DashboardService(this._remindersService);

  final RemindersService _remindersService;

  /// Fetches the next page of reminders for the dashboard
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

  /// Fetches the dashboard counters model containing details about the number
  /// of complete and incomplete reminders
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

  /// Determines how a reminder should be managed based on its due date and
  /// completion status. If the reminder's due date is within a certain range
  /// and it is not complete, it should be merged; if it is complete or its due
  /// date is not within the range, it should be removed. Returns the
  /// appropriate [ManageOperation] for the reminder.
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

  /// Returns a new dashboard counters model with updated number of complete and
  /// incomplete reminders based on the [counterOperation] that was performed
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
  /// Method used to recalculate the number of incomplete reminders based on
  /// the [counterOperation] that was performed
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

  /// Method used to recalculate the number of complete reminders based on
  /// the [counterOperation] that was performed
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
