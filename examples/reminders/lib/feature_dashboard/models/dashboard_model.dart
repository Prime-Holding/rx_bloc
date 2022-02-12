import '../../base/models/reminder/reminder_model.dart';

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
    int? incompleteCount,
    int? completeCount,
  }) =>
      DashboardModel(
        reminderList: reminderList ?? this.reminderList,
        incompleteCount: incompleteCount ?? this.incompleteCount,
        completeCount: completeCount ?? this.completeCount,
      );
}
