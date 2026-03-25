{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/base/common_blocs/coordinator_bloc.dart';
import 'package:{{project_name}}/base/models/notification_event_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notifications_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notifications_response_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/services/in_app_notifications_service.dart';

import '../../base/common_blocs/coordinator_bloc_mock.dart';
import '../../base/stubs.dart';
import 'in_app_notifications_bloc_test.mocks.dart';

@GenerateMocks([InAppNotificationsService])
void main() {
  late MockInAppNotificationsService service;
  late CoordinatorBlocType coordinatorBloc;
  late CoordinatorStates coordinatorStates;

  void defineWhen({
    InAppNotificationsResponseModel? response,
    Object? error,
    int page = 0,
    int pageSize = 10,
    bool unreadOnly = false,
  }) {
    if (error != null) {
      when(
        service.getNotifications(
          page: page,
          pageSize: pageSize,
          unreadOnly: unreadOnly,
        ),
      ).thenThrow(error);
    } else {
      when(
        service.getNotifications(
          page: page,
          pageSize: pageSize,
          unreadOnly: unreadOnly,
        ),
      ).thenAnswer(
          (_) async => response ?? Stubs.inAppNotificationsResponseFirstPage);
    }
  }

  InAppNotificationsBloc buildBloc() =>
      InAppNotificationsBloc(service, coordinatorBloc);

  setUp(() {
    service = MockInAppNotificationsService();
    coordinatorStates = coordinatorStatesMockFactory();
    when(coordinatorStates.notificationEvents).thenAnswer(
      (_) => const Stream<NotificationEvent>.empty(),
    );
    coordinatorBloc = coordinatorBlocMockFactory(states: coordinatorStates);
  });

  group('InAppNotificationsBloc loadNotifications tests', () {
    test(
      'test InAppNotificationsBloc loadNotifications - unreadCount reflects response',
      () async {
        defineWhen();
        final bloc = buildBloc();
        // Drive pagination pipeline; unread count is updated inside the same load path.
        bloc.states.notifications.listen((_) {});
        await expectLater(
          bloc.states.unreadCount,
          emitsInOrder(<int>[0, 1]),
        );
        bloc.dispose();
      },
    );
  });
}
