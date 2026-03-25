{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/base/models/notification_event_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/unread_notifications_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/services/in_app_notifications_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import 'unread_notifications_bloc_test.mocks.dart';

@GenerateMocks([InAppNotificationsService])
void main() {
  late MockInAppNotificationsService service;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorStates;

  void defineWhen({required int unreadCount}) {
    when(service.getUnreadCount()).thenAnswer((_) async => unreadCount);
  }

  UnreadNotificationsBloc buildBloc() =>
      UnreadNotificationsBloc(service, coordinatorBloc);

  setUp(() {
    service = MockInAppNotificationsService();
    coordinatorStates = coordinatorStatesMockFactory();
    when(coordinatorStates.notificationEvents).thenAnswer(
      (_) => const Stream<NotificationEvent>.empty(),
    );
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorStates);
  });

  group('UnreadNotificationsBloc fetchUnreadNotifications tests', () {
    rxBlocTest<UnreadNotificationsBlocType, int>(
      'test UnreadNotificationsBloc fetchUnreadNotifications - updates count on subscribe',
      build: () async {
        defineWhen(unreadCount: 7);
        return buildBloc();
      },
      state: (bloc) => bloc.states.inAppNotificationCount,
      expect: const [0, 7],
    );
  });
}
