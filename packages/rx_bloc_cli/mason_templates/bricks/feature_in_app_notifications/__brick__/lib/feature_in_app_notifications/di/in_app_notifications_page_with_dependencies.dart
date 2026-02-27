import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/in_app_notifications_bloc.dart';
import '../views/in_app_notifications_page.dart';

class InAppNotificationsPageWithDependencies extends StatelessWidget {
  const InAppNotificationsPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          RxBlocProvider<InAppNotificationsBlocType>(
            create: (context) => InAppNotificationsBloc(context.read()),
          ),
        ],
        child: const InAppNotificationsPage(),
      );

}
