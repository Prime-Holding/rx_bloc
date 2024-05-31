import 'package:objectbox/objectbox.dart';
import 'package:rx_bloc_list/models.dart';

import 'reminder_model.dart';

@Entity()
class ObjectBoxLocalReminderModel extends ReminderModel {
  ObjectBoxLocalReminderModel({
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
      other is ObjectBoxLocalReminderModel &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  ObjectBoxLocalReminderModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? complete,
    String? authorId,
  }) =>
      ObjectBoxLocalReminderModel(
        index: index,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        complete: complete ?? this.complete,
        authorId: authorId ?? this.authorId,
      );
}

@Entity()
@Sync()
class ObjectBoxCloudReminderModel extends ReminderModel {
  ObjectBoxCloudReminderModel({
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
      other is ObjectBoxCloudReminderModel &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  ObjectBoxCloudReminderModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? complete,
    String? authorId,
  }) =>
      ObjectBoxCloudReminderModel(
        index: index,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        complete: complete ?? this.complete,
        authorId: authorId ?? this.authorId,
      );
}
