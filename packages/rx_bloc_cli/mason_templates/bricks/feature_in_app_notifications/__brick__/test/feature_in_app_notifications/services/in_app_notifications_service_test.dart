{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:{{project_name}}/feature_in_app_notifications/repositories/in_app_notifications_repository.dart';
import 'package:{{project_name}}/feature_in_app_notifications/services/in_app_notifications_service.dart';

import '../../base/stubs.dart';
import 'in_app_notifications_service_test.mocks.dart';

@GenerateMocks([InAppNotificationsRepository])
void main() {
  late MockInAppNotificationsRepository repository;
  late InAppNotificationsService service;

  setUp(() {
    repository = MockInAppNotificationsRepository();
    service = InAppNotificationsService(repository);
  });

  group('InAppNotificationsService getUnreadCount tests', () {
    test(
      'test InAppNotificationsService getUnreadCount - returns unreadCount from minimal fetch',
      () async {
        when(
          repository.getNotifications(page: 0, pageSize: 1, unreadOnly: false),
        ).thenAnswer((_) async => Stubs.inAppNotificationsResponseUnreadOnly);

        final result = await service.getUnreadCount();

        expect(result, equals(42));
        verify(
          repository.getNotifications(page: 0, pageSize: 1, unreadOnly: false),
        ).called(1);
      },
    );
  });
}
