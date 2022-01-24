enum ReminderModelRequestSort {
  dueDateDesc,
  dueDateAsc,
}

class DueDateRange {
  DueDateRange({
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;
}

class ReminderModelRequest {
  ReminderModelRequest({
    this.filterByDueDateRange,
    this.sort,
    this.page = 0,
    this.pageSize = 50,
  });

  final DueDateRange? filterByDueDateRange;
  final ReminderModelRequestSort? sort;
  final int page;
  final int pageSize;
}

class ReminderModel {
  ReminderModel({
    required this.id,
    required this.title,
    required this.dueDate,
  });

  final String id;
  final String title;
  final DateTime dueDate;

  factory ReminderModel.fromIndex(int index) => ReminderModel(
        id: index.toString(),
        title: 'Reminder $index',
        dueDate: DateTime.now().add(
          Duration(days: index),
        ),
      );

  ReminderModel copyWith({
    String? title,
    DateTime? dueDate,
  }) =>
      ReminderModel(
        id: id,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
      );
}
