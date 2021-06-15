import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/send_notifications_bloc.dart';

class NotificationsDependencies {
  NotificationsDependencies._(this.context);

  factory NotificationsDependencies.of(BuildContext context) =>
      _instance != null
          ? _instance!
          : _instance = NotificationsDependencies._(context);

  static NotificationsDependencies? _instance;

  final BuildContext context;

  /// List of all providers used throughout the app
  List<SingleChildWidget> get providers => [
        ..._blocs,
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SendNotificationsBlocType>(
          create: (context) => SendNotificationsBloc(
            context.read(),
          ),
        ),
      ];
}
