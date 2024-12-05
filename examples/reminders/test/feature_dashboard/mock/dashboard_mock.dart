import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminders/base/models/reminder/reminder_model.dart';
import 'package:reminders/feature_dashboard/blocs/dashboard_bloc.dart';
import 'package:reminders/feature_dashboard/models/dashboard_model.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import 'dashboard_mock.mocks.dart';

@GenerateMocks([DashboardBlocStates, DashboardBlocEvents, DashboardBlocType])
DashboardBlocType dashboardMockFactory({
  bool? isLoading,
  String? errors,
  Result<DashboardCountersModel>? dashboardCounters,
  PaginatedList<ReminderModel>? reminderModels,
}) {
  final blocMock = MockDashboardBlocType();
  final eventsMock = MockDashboardBlocEvents();
  final statesMock = MockDashboardBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final isLoadingState = isLoading != null
      ? Stream.value(isLoading).shareReplay(maxSize: 1)
      : const Stream<bool>.empty();

  final errorsState = errors != null
      ? Stream.value(errors).shareReplay(maxSize: 1)
      : const Stream<String>.empty();

  final dashboardCountersState = dashboardCounters != null
      ? Stream.value(dashboardCounters).shareReplay(maxSize: 1)
      : const Stream<Result<DashboardCountersModel>>.empty();

  final reminderModelsState = reminderModels != null
      ? Stream.value(reminderModels).shareReplay(maxSize: 1)
      : const Stream<PaginatedList<ReminderModel>>.empty();

  when(statesMock.isLoading).thenAnswer((_) => isLoadingState);
  when(statesMock.errors).thenAnswer((_) => errorsState);
  when(statesMock.dashboardCounters).thenAnswer((_) => dashboardCountersState);
  when(statesMock.reminderModels).thenAnswer((_) => reminderModelsState);

  return blocMock;
}
