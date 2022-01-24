import '../../base/models/reminder_model.dart';

class DashboardModel {
  DashboardModel({
    required this.reminderList,
    required this.incompleteCount,
    required this.completeCount,
  });

  final List<ReminderModel> reminderList;
  final int incompleteCount;
  final int completeCount;

  DashboardModel copyWith({
    List<ReminderModel>? reminderList,
    int? allReminderCount,
    int? completeReminderCount,
  }) =>
      DashboardModel(
        reminderList: reminderList ?? this.reminderList,
        incompleteCount: allReminderCount ?? this.incompleteCount,
        completeCount: completeReminderCount ?? this.completeCount,
      );
}
