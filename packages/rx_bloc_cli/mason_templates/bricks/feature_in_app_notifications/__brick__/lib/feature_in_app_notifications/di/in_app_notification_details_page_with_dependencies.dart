import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/in_app_notification_details_bloc.dart';
import '../views/in_app_notification_details_page.dart';

class InAppNotificationDetailsPageWithDependencies extends StatelessWidget {
  const InAppNotificationDetailsPageWithDependencies({
    required this.notificationId,
    super.key,
  });

  final String notificationId;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
        RxBlocProvider<InAppNotificationDetailsBlocType>(
          create: (context) => InAppNotificationDetailsBloc(
              context.read(),
              notificationId: notificationId,
            ),
          ),
        ],
        child: InAppNotificationDetailsPage(notificationId: notificationId),
      );


}
