{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notifications_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notification_model.dart';

import 'in_app_notifications_mock.mocks.dart';

@GenerateMocks([
  InAppNotificationsBlocStates,
  InAppNotificationsBlocEvents,
  InAppNotificationsBlocType,
])
InAppNotificationsBlocType inAppNotificationsMockFactory({
  required PaginatedList<InAppNotificationModel> listState,
  bool isFilteredByUnread = false,
  int unreadCount = 0,
}) {
  final blocMock = MockInAppNotificationsBlocType();
  final eventsMock = MockInAppNotificationsBlocEvents();
  final statesMock = MockInAppNotificationsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  final notificationsStream =
      Stream.value(listState).shareReplay(maxSize: 1);

  when(statesMock.notifications).thenAnswer((_) => notificationsStream);
  when(statesMock.isFilteredByUnread).thenAnswer(
    (_) => Stream.value(isFilteredByUnread).shareReplay(maxSize: 1),
  );
  when(statesMock.unreadCount).thenAnswer(
    (_) => Stream.value(unreadCount).shareReplay(maxSize: 1),
  );

  return blocMock;
}
