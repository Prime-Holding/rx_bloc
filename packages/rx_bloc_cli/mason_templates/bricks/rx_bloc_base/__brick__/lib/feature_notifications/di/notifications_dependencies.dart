{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/notifications_bloc.dart';

class NotificationsDependencies {
  NotificationsDependencies._(this.context);

  factory NotificationsDependencies.of(BuildContext context) =>
      _instance != null
          ? _instance!
          : _instance = NotificationsDependencies._(context);

  static NotificationsDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._blocs,
  ];

  late final List<Provider> _repositories = [];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<NotificationsBlocType>(
      create: (context) => NotificationsBloc(context.read()),
    ),
  ];
}
