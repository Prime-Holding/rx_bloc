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
     this.authorId,
  });

  final String title;
  final DateTime dueDate;
  final bool complete;
  final String? authorId;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'dueDate': dueDate,
      'complete': complete,
      'authorId': authorId,
    };
  }
}

class ReminderModel extends ReminderModelRequestData implements Identifiable {
  ReminderModel({
    required this.id,
    required title,
    required dueDate,
    required complete,
    authorId,
  }) : super(
            title: title,
            dueDate: dueDate,
            complete: complete,
            authorId: authorId);

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

  factory ReminderModel.withAuthorId(int index, String authorId) =>
      ReminderModel(
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
        authorId: authorId,
      );

  ReminderModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? complete,
    String? authorId,
  }) =>
      ReminderModel(
        id: id ?? this.id,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        complete: complete ?? this.complete,
        authorId: authorId ?? this.authorId,
      );

  ReminderModel.fromJson(Map<String, dynamic> json, String id)
      : this(
          id: id,
          title: json['title'] as String,
          dueDate: json['dueDate'].toDate(),
          complete: json['complete'] as bool,
          authorId: json['authorId'] as String,
        );
}
