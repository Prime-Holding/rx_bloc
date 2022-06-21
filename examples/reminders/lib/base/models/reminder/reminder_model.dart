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

class ReminderModelRequestData {
  ReminderModelRequestData({
    required this.title,
    required this.dueDate,
    required this.complete,
  });

  final String title;
  final DateTime dueDate;
  final bool complete;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'complete': complete,
    };
  }
}

class ReminderModel extends ReminderModelRequestData implements Identifiable {
  ReminderModel({
    required this.id,
    required title,
    required dueDate,
    required complete,
  }) : super(title: title, dueDate: dueDate, complete: complete);

  @override
  final String id;

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
      );

  ReminderModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? complete,
  }) =>
      ReminderModel(
        id: id ?? this.id,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        complete: complete ?? this.complete,
      );

  ReminderModel.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: id,
          title: json['title'] as String,
          dueDate: json['dueDate'].toDate(),
          complete: json['complete'] as bool,
        );
}
