import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_app/feature_notifications/blocs/notifications_bloc.dart';

import 'notifications_bloc_mock.mocks.dart';

@GenerateMocks([
  NotificationsBlocEvents,
  NotificationsBlocStates,
  NotificationsBlocType,
])
NotificationsBlocType notificationsBlocMockFactory({
  bool? permissionsAuthorized,
}) {
  final notificationsBloc = MockNotificationsBlocType();
  final eventsMock = MockNotificationsBlocEvents();
  final statesMock = MockNotificationsBlocStates();

  when(notificationsBloc.events).thenReturn(eventsMock);
  when(notificationsBloc.states).thenReturn(statesMock);

  when(statesMock.permissionsAuthorized).thenAnswer(
    (_) => permissionsAuthorized != null
        ? Stream.value(permissionsAuthorized)
        : const Stream.empty(),
  );

  return notificationsBloc;
}
