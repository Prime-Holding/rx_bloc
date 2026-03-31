{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';

import '../../base/stubs.dart';
import '../../helpers/golden_helper.dart';
import 'factory/in_app_notification_details_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'in_app_notification_details_loading',
      widget: inAppNotificationDetailsFactory(
        notificationId: Stubs.inAppNotificationId1,
        notification: Result.loading(),
      ),
    ),
    buildScenario(
      scenario: 'in_app_notification_details_error',
      widget: inAppNotificationDetailsFactory(
        notificationId: Stubs.inAppNotificationId1,
        notification: Result.error(Stubs.unknownError),
      ),
    ),
    buildScenario(
      scenario: 'in_app_notification_details_success_plain',
      widget: inAppNotificationDetailsFactory(
        notificationId: Stubs.inAppNotificationId1,
        notification: Result.success(Stubs.inAppNotificationPlainDetails),
      ),
    ),
    buildScenario(
      scenario: 'in_app_notification_details_success_rich',
      widget: inAppNotificationDetailsFactory(
        notificationId: Stubs.inAppNotificationId1,
        notification: Result.success(Stubs.inAppNotificationRichDetails),
      ),
    ),
  ]);
}
