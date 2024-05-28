import 'package:realm/realm.dart';

part 'reminder_realm_model.realm.dart';

@RealmModel()
class _ReminderRealmModel {
  @PrimaryKey()
  late String id;
  late String title;
  late DateTime dueDate;
  late bool complete;
  late String? authorId;
}
