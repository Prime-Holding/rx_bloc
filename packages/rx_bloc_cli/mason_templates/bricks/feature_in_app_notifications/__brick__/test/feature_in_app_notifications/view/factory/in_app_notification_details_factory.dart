{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/blocs/in_app_notification_details_bloc.dart';
import 'package:{{project_name}}/feature_in_app_notifications/models/in_app_notification_model.dart';
import 'package:{{project_name}}/feature_in_app_notifications/views/in_app_notification_details_page.dart';

import '../../mock/in_app_notification_details_mock.dart';

Widget inAppNotificationDetailsFactory({
  required Result<InAppNotificationModel> notification,
  required String notificationId,
}) =>
    RxBlocProvider<InAppNotificationDetailsBlocType>.value(
      value: inAppNotificationDetailsMockFactory(notification: notification),
      child: InAppNotificationDetailsPage(notificationId: notificationId),
    );
