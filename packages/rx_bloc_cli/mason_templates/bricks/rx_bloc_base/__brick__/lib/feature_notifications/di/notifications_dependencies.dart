{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/notifications_bloc.dart';
import '../services/notifications_service.dart';

class NotificationsDependencies {
  NotificationsDependencies._(this.context);

  factory NotificationsDependencies.from(BuildContext context) =>
      NotificationsDependencies._(context);

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._services,
    ..._blocs,
  ];

  late final List<Provider> _services = [
    Provider<NotificationService>(
      create: (context) => NotificationService(
        context.read(),
      ),
    )
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<NotificationsBlocType>(
      create: (context) => NotificationsBloc(context.read()),
    ),
  ];
}
