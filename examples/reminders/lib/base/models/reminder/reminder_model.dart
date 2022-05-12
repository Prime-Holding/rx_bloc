import 'package:rx_bloc_list/models.dart';

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

class ReminderModel implements Identifiable {
  ReminderModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.complete,
    required this.completeUpdated,
  });

  @override
  final String id;
  final String title;
  final DateTime dueDate;
  final bool complete;

  /// Shows whether during update operation the complete flag was changed
  final bool completeUpdated;

  factory ReminderModel.fromIndex(int index) => ReminderModel(
        id: index.toString(),
        title: 'Reminder $index',
        complete: false,
        dueDate: DateTime.now()
            .subtract(
              const Duration(days: 100),
            )
            .add(
              Duration(days: index),
            ),
        completeUpdated: false,
      );

  ReminderModel copyWith({
    String? title,
    DateTime? dueDate,
    bool? complete,
    bool? completeUpdated,
  }) =>
      ReminderModel(
        id: id,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        complete: complete ?? this.complete,
        completeUpdated: completeUpdated ?? this.completeUpdated,
      );
}
