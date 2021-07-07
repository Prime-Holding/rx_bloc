// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test_app/base/repositories/push_notification_repository.dart';
import 'package:test_app/feature_notifications/blocs/notifications_bloc.dart';

import '../../helpers/stubs.dart';
import 'notifications_bloc_test.mocks.dart';

@GenerateMocks([PushNotificationRepository])
void main() {
  late MockPushNotificationRepository pushNotificationRepository;

  setUp(() {
    pushNotificationRepository = MockPushNotificationRepository();
  });

  group('NotificationsBloc tests', () {
    rxBlocTest<NotificationsBlocType, bool>(
      'Request notifications permission - granted',
      build: () async {
        when(pushNotificationRepository.requestNotificationPermissions())
            .thenAnswer((realInvocation) => Future.value(true));
        return NotificationsBloc(pushNotificationRepository);
      },
      act: (bloc) async => bloc.events.requestNotificationPermissions(),
      state: (bloc) => bloc.states.permissionsAuthorized,
      expect: [true],
    );

    rxBlocTest<NotificationsBlocType, bool>(
      'Request notifications permission - declined',
      build: () async {
        when(pushNotificationRepository.requestNotificationPermissions())
            .thenAnswer((realInvocation) => Future.value(false));
        return NotificationsBloc(pushNotificationRepository);
      },
      act: (bloc) async => bloc.events.requestNotificationPermissions(),
      state: (bloc) => bloc.states.permissionsAuthorized,
      expect: [false],
    );

    rxBlocTest<NotificationsBlocType, bool>(
      'Send message',
      build: () async {
        when(pushNotificationRepository.requestNotificationPermissions())
            .thenAnswer((realInvocation) => Future.value(false));
        return NotificationsBloc(pushNotificationRepository);
      },
      act: (bloc) async => bloc.events.sendMessage(Stubs.notificationMessage),
      state: (bloc) => bloc.states.permissionsAuthorized,
      expect: [true],
    );

    rxBlocTest<NotificationsBlocType, bool>(
      'Send message with delay',
      build: () async {
        when(pushNotificationRepository.requestNotificationPermissions())
            .thenAnswer((realInvocation) => Future.value(false));
        return NotificationsBloc(pushNotificationRepository);
      },
      act: (bloc) async => bloc.events.sendMessage(
        Stubs.notificationMessage,
        delay: 10,
      ),
      state: (bloc) => bloc.states.permissionsAuthorized,
      expect: [true],
    );
  });
}
