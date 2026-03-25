{{> licence.dart }}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notification_details_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notification_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/services/in_app_notifications_service.dart';

import '../../base/stubs.dart';
import 'in_app_notification_details_bloc_test.mocks.dart';

@GenerateMocks([InAppNotificationsService])
void main() {
  late MockInAppNotificationsService service;

  void defineWhen({
    required String id,
    InAppNotificationModel? model,
    Object? error,
  }) {
    if (error != null) {
      when(service.getNotificationById(id)).thenAnswer(
        (_) => Future<InAppNotificationModel>.error(error),
      );
    } else {
      when(service.getNotificationById(id)).thenAnswer((_) async => model!);
    }
  }

  InAppNotificationDetailsBloc buildBloc({required String notificationId}) =>
      InAppNotificationDetailsBloc(service, notificationId: notificationId);

  setUp(() {
    service = MockInAppNotificationsService();
  });

  group('InAppNotificationDetailsBloc fetchNotification tests', () {
    rxBlocTest<InAppNotificationDetailsBlocType,
        Result<InAppNotificationModel>>(
      'test InAppNotificationDetailsBloc fetchNotification - success on initial load',
      build: () async {
        defineWhen(
          id: Stubs.inAppNotificationId1,
          model: Stubs.inAppNotificationPlainDetails,
        );
        return buildBloc(notificationId: Stubs.inAppNotificationId1);
      },
      state: (bloc) => bloc.states.notification,
      expect: [
        Result.loading(),
        Result.success(Stubs.inAppNotificationPlainDetails),
      ],
    );

    rxBlocTest<InAppNotificationDetailsBlocType,
        Result<InAppNotificationModel>>(
      'test InAppNotificationDetailsBloc fetchNotification - error',
      build: () async {
        defineWhen(
          id: Stubs.inAppNotificationId1,
          error: Stubs.unknownError,
        );
        return buildBloc(notificationId: Stubs.inAppNotificationId1);
      },
      state: (bloc) => bloc.states.notification,
      expect: [
        Result.loading(),
        Result.error(Stubs.unknownError),
      ],
    );
  });
}
