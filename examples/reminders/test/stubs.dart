import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/feature_dashboard/models/dashboard_model.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

class Stubs {
  static PaginatedList<ReminderModel> get reminderPaginatedList =>
      PaginatedList<ReminderModel>(list: [
        createReminderNote(id: '1', name: 'reminder_note_1', completed: true),
        createReminderNote(id: '2', name: 'reminder_note_2'),
        createReminderNote(id: '3', name: 'reminder_note_3'),
        createReminderNote(id: '4', name: 'reminder_note_4'),
        createReminderNote(id: '5', name: 'reminder_note_5', completed: true),
        createReminderNote(id: '6', name: 'reminder_note_6'),
        createReminderNote(id: '7', name: 'reminder_note_7', completed: true),
        createReminderNote(id: '8', name: 'reminder_note_8', completed: true),
        createReminderNote(
          id: '9',
          name: 'reminder_note_9',
        ),
      ], pageSize: 10, totalCount: 9, isLoading: false, isInitialized: true);

  static ReminderModel reminderNote(int index) => ReminderModel.fromIndex(index)
      .copyWith(dueDate: DateTime(2027, index, index % 12));

  static ReminderModel createReminderNote(
          {required String id, required String name, bool completed = false}) =>
      ReminderModel(id: id, title: name, dueDate: dueDate, complete: false);

  static ReminderModel get createdReminderNote => ReminderModel(
      id: '1', title: noteNameValid, dueDate: dueDate, complete: false);

  static ReminderModel get updatedReminderNote => ReminderModel(
      id: '1', title: noteNameValid, dueDate: dueDate, complete: true);

  static ReminderPair get reminderPairNote =>
      ReminderPair(updated: updatedReminderNote, old: createdReminderNote);

  static DashboardCountersModel get dashboardCountersModel =>
      DashboardCountersModel(
        incompleteCount: 5,
        completeCount: 4,
      );

  static PaginatedList<ReminderModel> get paginatedListEmpty =>
      PaginatedList<ReminderModel>(
        list: [],
        pageSize: 10,
      );

  static BehaviorSubject<PaginatedList<ReminderModel>>
      get subjectOfPaginatedList =>
          BehaviorSubject<PaginatedList<ReminderModel>>.seeded(
            PaginatedList<ReminderModel>(
              list: [],
              pageSize: 10,
            ),
          );

  static Exception get throwable => Exception(['An error occur!']);

  static RxFieldException<String> fieldException(String fieldValue) =>
      RxFieldException<String>(
          error: 'A title must be specified', fieldValue: fieldValue);

  static const String errorNoConnection =
      'There is no internet connection. Please, try again later!';
  static const String emptyString = '';
  static const String noteNameValid = 'noteNameValid';
  static DateTime get dueDate => DateTime(2029);
  // static RxFieldException get throwable1 => RxFieldException(
  // fieldValue: name,
  // error: '_nameValidation',
  // );
}
