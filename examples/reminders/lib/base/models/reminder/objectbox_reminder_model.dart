import 'package:objectbox/objectbox.dart';

@Entity()
class ObjectBoxLocalReminderModel {
  ObjectBoxLocalReminderModel({
    this.id = 0,
    required this.title,
    required this.dueDate,
    required this.complete,
    this.authorId,
  });

  @Id()
  int id;
  final String title;
  final DateTime dueDate;
  final bool complete;
  final String? authorId;
}

@Entity()
@Sync()
class ObjectBoxCloudReminderModel {
  ObjectBoxCloudReminderModel({
    this.id = 0,
    required this.title,
    required this.dueDate,
    required this.complete,
    this.authorId,
  });

  @Id()
  int id;
  final String title;
  final DateTime dueDate;
  final bool complete;
  final String? authorId;
}
