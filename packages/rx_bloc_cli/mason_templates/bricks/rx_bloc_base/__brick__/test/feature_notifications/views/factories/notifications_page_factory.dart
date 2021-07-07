import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_app/feature_notifications/blocs/notifications_bloc.dart';
import 'package:test_app/feature_notifications/views/notifications_page.dart';

import '../../mocks/notifications_bloc_mock.dart';

/// wraps a [NotificationsPage] in a [Provider] of type [NotificationsBlocType],
/// creating a mocked bloc depending on the values being tested
Widget notificationsPageFactory({
  bool? permissionsAuthorized,
}) =>
    Provider<NotificationsBlocType>(
      create: (_) => notificationsBlocMockFactory(
          permissionsAuthorized: permissionsAuthorized),
      child: const NotificationsPage(),
    );
