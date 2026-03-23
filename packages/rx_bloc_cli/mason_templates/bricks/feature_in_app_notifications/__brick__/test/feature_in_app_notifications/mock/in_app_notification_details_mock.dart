{{> licence.dart }}

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notification_details_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notification_model.dart';

import 'in_app_notification_details_mock.mocks.dart';

@GenerateMocks([
  InAppNotificationDetailsBlocStates,
  InAppNotificationDetailsBlocEvents,
  InAppNotificationDetailsBlocType,
])
InAppNotificationDetailsBlocType inAppNotificationDetailsMockFactory({
  required Result<InAppNotificationModel> notification,
}) {
  final blocMock = MockInAppNotificationDetailsBlocType();
  final eventsMock = MockInAppNotificationDetailsBlocEvents();
  final statesMock = MockInAppNotificationDetailsBlocStates();

  when(blocMock.events).thenReturn(eventsMock);
  when(blocMock.states).thenReturn(statesMock);

  when(statesMock.notification).thenAnswer(
    (_) => Stream.value(notification).shareReplay(maxSize: 1),
  );

  return blocMock;
}
