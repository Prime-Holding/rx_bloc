// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:testapp/base/models/errors/error_model.dart';
import 'package:testapp/feature_notifications/blocs/notifications_bloc.dart';
import 'package:testapp/feature_notifications/views/notifications_page.dart';

import '../../mocks/notifications_bloc_mock.dart';

/// wraps a [NotificationsPage] in a [Provider] of type [NotificationsBlocType], creating
/// a mocked bloc depending on the values being tested
Widget notificationsPageFactory({ErrorModel? error, String? pushToken}) =>
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
