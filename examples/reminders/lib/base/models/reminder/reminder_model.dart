import 'package:json_annotation/json_annotation.dart';
import 'package:rx_bloc_list/models.dart';

part 'reminder_model.g.dart';

enum ReminderModelRequestSort {
  dueDateDesc,
  dueDateAsc,
}

@JsonSerializable()
class DueDateRange {
  DueDateRange({
    required this.from,
    required this.to,
  });

  final DateTime from;
  final DateTime to;
  Map<String, dynamic> toJson() => _$DueDateRangeToJson(this);

  factory DueDateRange.fromJson(Map<String, dynamic> json) =>
      _$DueDateRangeFromJson(json);
}

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$ReminderModelRequestToJson(this);

  factory ReminderModelRequest.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelRequestFromJson(json);
}

@JsonSerializable()
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

  Map<String, dynamic> toJson() => _$ReminderModelRequestDataToJson(this);

  factory ReminderModelRequestData.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelRequestDataFromJson(json);
}

@JsonSerializable()
class ReminderModel extends ReminderModelRequestData implements Identifiable {
  ReminderModel({
    required this.id,
    required super.title,
    required super.dueDate,
    required super.complete,
    authorId,
  });

  final String id;
  @override
  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);

  @override
  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);

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

  @override
  bool isEqualToIdentifiable(Identifiable other) =>
      identical(this, other) ||
      other is ReminderModel &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

@JsonSerializable()
class ReminderPair {
  ReminderPair({required this.updated, required this.old});

  final ReminderModel updated;

  final ReminderModel old;

  Map<String, dynamic> toJson() => _$ReminderPairToJson(this);

  factory ReminderPair.fromJson(Map<String, dynamic> json) =>
      _$ReminderPairFromJson(json);
}
