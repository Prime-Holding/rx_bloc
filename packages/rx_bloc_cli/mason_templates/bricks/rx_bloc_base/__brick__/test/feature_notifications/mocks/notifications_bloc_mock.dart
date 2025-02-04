import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_notifications/blocs/notifications_bloc.dart';

import 'notifications_bloc_mock.mocks.dart';

@GenerateMocks([
  NotificationsBlocEvents,
  NotificationsBlocStates,
  NotificationsBlocType,
])
NotificationsBlocType notificationsBlocMockFactory({
  String? pushToken,
  ErrorModel? error,
}) {
  final notificationsBloc = MockNotificationsBlocType();
  final eventsMock = MockNotificationsBlocEvents();
  final statesMock = MockNotificationsBlocStates();

  when(notificationsBloc.events).thenReturn(eventsMock);
  when(notificationsBloc.states).thenReturn(statesMock);

  final pushTokenState = (pushToken != null
          ? Stream.value(Result.success(pushToken))
          : Stream<Result<String>>.value(
              Result<String>.error(NotFoundErrorModel())))
      .publishReplay(maxSize: 1)
    ..connect();

  when(statesMock.pushToken).thenAnswer(
    (_) => pushTokenState,
  );

  when(statesMock.errors).thenAnswer(
    (_) => error != null ? Stream.value(error) : const Stream.empty(),
  );

  return notificationsBloc;
}
