import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'reminder_manage_mock.mocks.dart';

@GenerateMocks([
  ReminderManageBlocStates,
  ReminderManageBlocEvents,
  ReminderManageBlocType
])
ReminderManageBlocType reminderManageMockFactory({
  bool? isFormValid,
  bool? showErrors,
  String? name,
  Result<ReminderModel>? newReminderNote,
  Result<ReminderModel>? deletedReminderNote,
  Result<ReminderPair>? updatedReminderNote,
}) {
  final blocMock = MockReminderManageBlocType();
  final eventsMock = MockReminderManageBlocEvents();
  final statesMock = MockReminderManageBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isFormValidState = (isFormValid != null
          ? Stream.value(isFormValid)
          : const Stream<bool>.empty())
      .shareReplay(maxSize: 1);

  final showErrorsState = (showErrors != null
          ? Stream.value(showErrors)
          : const Stream<bool>.empty())
      .shareReplay(maxSize: 1);

  final nameState =
      (name != null ? Stream.value(name) : const Stream<String>.empty())
          .shareReplay(maxSize: 1);

  final onCreatedState = (newReminderNote != null
          ? Stream.value(newReminderNote)
          : const Stream<Result<ReminderModel>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final onDeletedState = (deletedReminderNote != null
          ? Stream.value(deletedReminderNote)
          : const Stream<Result<ReminderModel>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  final onUpdatedState = (updatedReminderNote != null
          ? Stream.value(updatedReminderNote)
          : const Stream<Result<ReminderPair>>.empty())
      .publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.isFormValid).thenAnswer((_) => isFormValidState);
  when(statesMock.showErrors).thenAnswer((_) => showErrorsState);
  when(statesMock.name).thenAnswer((_) => nameState);
  when(statesMock.onCreated).thenAnswer((_) => onCreatedState);
  when(statesMock.onDeleted).thenAnswer((_) => onDeletedState);
  when(statesMock.onUpdated).thenAnswer((_) => onUpdatedState);

  return blocMock;
}
