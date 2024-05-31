// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/notifications_bloc.dart';
import '../services/notifications_service.dart';
import '../views/notifications_page.dart';

class NotificationsPageWithDependencies extends StatelessWidget {
  const NotificationsPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const NotificationsPage(),
      );

  List<Provider> get _services => [
        Provider<NotificationService>(
          create: (context) => NotificationService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<NotificationsBlocType>(
          create: (context) => NotificationsBloc(context.read()),
        ),
      ];
}
