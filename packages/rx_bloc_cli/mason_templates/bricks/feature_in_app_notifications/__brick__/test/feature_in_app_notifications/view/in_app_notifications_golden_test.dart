{{> licence.dart }}

import '../../base/stubs.dart';
import '../../helpers/golden_helper.dart';
import 'factory/in_app_notifications_factory.dart';

void main() {
  runGoldenTests([
    buildScenario(
      scenario: 'in_app_notifications_loading',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedLoading,
      ),
    ),
    buildScenario(
      scenario: 'in_app_notifications_error',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedError,
      ),
    ),
    buildScenario(
      scenario: 'in_app_notifications_empty',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedEmpty,
      ),
    ),
    buildScenario(
      scenario: 'in_app_notifications_success',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedWithItems,
        unreadCount: 1,
      ),
    ),
    buildScenario(
      scenario: 'in_app_notifications_success_filtered',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedWithItems,
        isFilteredByUnread: true,
        unreadCount: 1,
      ),
    ),
    buildScenario(
      scenario: 'in_app_notifications_success_loading_more',
      widget: inAppNotificationsFactory(
        listState: Stubs.inAppNotificationsPaginatedLoadingMore,
        unreadCount: 1,
      ),
    ),
  ]);
}
