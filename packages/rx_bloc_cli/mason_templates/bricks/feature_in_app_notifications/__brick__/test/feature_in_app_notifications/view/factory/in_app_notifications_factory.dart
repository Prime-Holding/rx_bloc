{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notifications_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notification_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/views/in_app_notifications_page.dart';

import '../../mock/in_app_notifications_mock.dart';

Widget inAppNotificationsFactory({
  required PaginatedList<InAppNotificationModel> listState,
  bool isFilteredByUnread = false,
  int unreadCount = 0,
}) =>
    RxBlocProvider<InAppNotificationsBlocType>.value(
      value: inAppNotificationsMockFactory(
        listState: listState,
        isFilteredByUnread: isFilteredByUnread,
        unreadCount: unreadCount,
      ),
      child: const InAppNotificationsPage(),
    );
