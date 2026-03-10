import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/unread_notifications_bloc.dart';

import 'unread_notifications_bloc_mock.mocks.dart';

@GenerateMocks([
  UnreadNotificationsBlocEvents,
  UnreadNotificationsBlocStates,
  UnreadNotificationsBlocType,
])
UnreadNotificationsBlocType unreadNotificationsBlocMockFactory({
  int notificationCount = 0,
}) {
  final blocMock = MockUnreadNotificationsBlocType();
  final eventsMock = MockUnreadNotificationsBlocEvents();
  final statesMock = MockUnreadNotificationsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.inAppNotificationCount).thenAnswer(
    (_) => Stream.value(notificationCount),
  );

  return blocMock;
}
