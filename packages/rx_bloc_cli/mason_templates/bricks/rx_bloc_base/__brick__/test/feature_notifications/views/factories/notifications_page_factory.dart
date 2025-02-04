{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:{{project_name}}/base/models/errors/error_model.dart';
import 'package:{{project_name}}/feature_notifications/blocs/notifications_bloc.dart';
import 'package:{{project_name}}/feature_notifications/views/notifications_page.dart';

import '../../mocks/notifications_bloc_mock.dart';

/// wraps a [NotificationsPage] in a [Provider] of type [NotificationsBlocType], creating
/// a mocked bloc depending on the values being tested
Widget notificationsPageFactory({
  ErrorModel? error,
  String? pushToken,
}) =>
    MultiProvider(
      providers: [
        RxBlocProvider<NotificationsBlocType>.value(
          value: notificationsBlocMockFactory(
            pushToken: pushToken,
            error: error,
          ),
        ),
      ],
      child: const NotificationsPage(),
    );
