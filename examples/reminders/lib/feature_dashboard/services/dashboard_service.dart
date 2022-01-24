import 'package:reminders/base/models/reminder_model.dart';
import 'package:reminders/feature_dashboard/models/dashboard_model.dart';

import '../../base/services/reminders_service.dart';

class DashboardService {
  DashboardService(this._remindersService);

  final RemindersService _remindersService;

  Future<DashboardModel> getDashboardModel() async {
    final data = await Future.wait([
      _remindersService.getCompleteCount(),
      _remindersService.getIncompleteCount(),
      _remindersService.getAll(
        ReminderModelRequest(
          page: 1,
          pageSize: 10,
          filterByDueDateRange: DueDateRange(
            to: DateTime.now(),
            from: DateTime.now().subtract(Duration(days: 10)),
          ),
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
}
