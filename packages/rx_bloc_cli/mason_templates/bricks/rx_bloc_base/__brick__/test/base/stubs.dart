import 'package:flutter/material.dart';{{#enable_in_app_notifications}}
import 'package:rx_bloc_list/rx_bloc_list.dart';{{/enable_in_app_notifications}}
import 'package:{{project_name}}/base/models/errors/error_model.dart';{{#realtime_communication}}
import 'package:{{project_name}}/base/models/response_models/sse_message_model.dart';{{/realtime_communication}}{{#enable_in_app_notifications}}
import 'package:testapp/feature_in_app_notifications/models/in_app_notification_model.dart';{{/enable_in_app_notifications}}

class Stubs {
  static const addIcon = Icon(Icons.add);

  static const removeIcon = Icon(Icons.remove);

  static const tooltip = 'This is a tooltip';

  static const appBarTitle = 'Some title';

  static const submit = 'Submit';

  static const customColor = Color.fromRGBO(100, 100, 100, 1);

  static final unknownError =
      UnknownErrorModel(exception: Exception('Some error occur'));

  {{#realtime_communication}}
  static const sseMessageModel = SseMessageModel(
    id: '1',
    data: 'Some message',
    event: 'event Name',
    retry: 1000,
  );
  {{/realtime_communication}} {{#enable_in_app_notifications}}

  static const inAppNotificationId1 = 'in-app-notification-1';

  static const inAppNotificationId2 = 'in-app-notification-2';

  /// Quill delta JSON for rich-body notification details.
  static const List<dynamic> inAppNotificationQuillBody = [
    {'insert': 'Rich notification body line.\n'},
  ];

  static final InAppNotificationModel inAppNotificationListItem1 =
  InAppNotificationModel(
    id: inAppNotificationId1,
    title: 'In-app notification title',
    description: 'First notification description text.',
    date: DateTime(2024, 3, 10),
    isUnread: true,
  );

  static final InAppNotificationModel inAppNotificationListItem2 =
  InAppNotificationModel(
    id: inAppNotificationId2,
    title: 'Second notification title',
    description: 'Second notification description text.',
    date: DateTime(2024, 3, 18),
    isUnread: false,
  );

  static final InAppNotificationModel inAppNotificationPlainDetails =
  InAppNotificationModel(
    id: inAppNotificationId1,
    title: 'Notification details title',
    description:
    'Plain description shown when the notification has no rich body.',
    date: DateTime(2024, 4, 2),
    isUnread: false,
  );

  static final InAppNotificationModel inAppNotificationRichDetails =
  InAppNotificationModel(
    id: inAppNotificationId1,
    title: 'Notification details title',
    description: 'Fallback description',
    date: DateTime(2024, 4, 2),
    isUnread: false,
    body: inAppNotificationQuillBody,
  );

  static PaginatedList<InAppNotificationModel>
  get inAppNotificationsPaginatedLoading =>
      PaginatedList<InAppNotificationModel>(
        list: [],
        pageSize: 10,
        isLoading: true,
      );

  static PaginatedList<InAppNotificationModel>
  get inAppNotificationsPaginatedError =>
      PaginatedList<InAppNotificationModel>(
        list: [],
        pageSize: 10,
        error: unknownError,
      );

  static PaginatedList<InAppNotificationModel>
  get inAppNotificationsPaginatedEmpty =>
      PaginatedList<InAppNotificationModel>(
        list: [],
        pageSize: 10,
        isLoading: false,
        isInitialized: true,
        totalCount: 0,
      );

  static PaginatedList<InAppNotificationModel>
  get inAppNotificationsPaginatedWithItems =>
      PaginatedList<InAppNotificationModel>(
        list: [inAppNotificationListItem1, inAppNotificationListItem2],
        pageSize: 10,
        isLoading: false,
        isInitialized: true,
        totalCount: 2,
      );

  static PaginatedList<InAppNotificationModel>
  get inAppNotificationsPaginatedLoadingMore =>
      PaginatedList<InAppNotificationModel>(
        list: [inAppNotificationListItem1, inAppNotificationListItem2],
        pageSize: 10,
        isLoading: true,
        isInitialized: true,
        totalCount: 10,
      );
  {{/enable_in_app_notifications}}
}
