import 'package:objectbox/objectbox.dart';
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
    this.complete,
  });

  final DueDateRange? filterByDueDateRange;
  final ReminderModelRequestSort? sort;
  final int page;
  final int pageSize;

  /// When fetching from the dashboard page, set complete to false
  final bool? complete;
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

@Entity()
@Sync()
class ObjectBoxReminderModel extends ReminderModel implements Identifiable {
  ObjectBoxReminderModel({
    this.index = 0,
    required super.title,
    required super.dueDate,
    required super.complete,
    super.authorId,
  }) : super(
          id: index.toString(),
        );

  @Id()
  int index;

  @override
  @Property()
  String get title => super.title;

  @override
  @Property()
  DateTime get dueDate => super.dueDate;

  @override
  @Property()
  bool get complete => super.complete;

  @override
  @Property()
  String? get authorId => super.authorId;

  @override
  @Property()
  String get id => super.id;

  @override
  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      other is ObjectBoxReminderModel &&
          runtimeType == other.runtimeType &&
          index == other.index;
}

class ReminderModel extends ReminderModelRequestData implements Identifiable {
  ReminderModel({
    required this.id,
    required super.title,
    required super.dueDate,
    required super.complete,
    super.authorId,
  });

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

  factory ReminderModel.withAuthorId(int index, String? authorId) {
    var now = DateTime.now();
    var date = now
        .subtract(const Duration(
          days: 10,
        ))
        .add(
          Duration(days: index),
        );
    return ReminderModel(
      id: index.toString(),
      title: 'Reminder $index',
      complete: false,
      dueDate: date,
      authorId: authorId,
    );
  }

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
          authorId: json['authorId'] as String?,
        );

  @override
  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      other is ReminderModel &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

class ReminderPair {
  ReminderPair({required this.updated, required this.old});

  final ReminderModel updated;

  final ReminderModel old;
}
