import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/feature_reminder_list/blocs/reminder_list_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import 'reminder_list_mock.mocks.dart';

@GenerateMocks(
    [ReminderListBlocStates, ReminderListBlocEvents, ReminderListBlocType])
ReminderListBlocType reminderListMockFactory({
  bool? isLoading,
  String? errors,
  PaginatedList<ReminderModel>? paginatedList,
}) {
  final blocMock = MockReminderListBlocType();
  final eventsMock = MockReminderListBlocEvents();
  final statesMock = MockReminderListBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final paginatedListState = paginatedList != null
      ? Stream.value(paginatedList).shareReplay(maxSize: 1)
      : const Stream<PaginatedList<ReminderModel>>.empty();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.paginatedList).thenAnswer((_) => paginatedListState);
  when(statesMock.refreshDone).thenAnswer((_) => Future.value(null));

  return blocMock;
}
