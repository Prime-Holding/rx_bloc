import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/reminder_list_bloc.dart';
import '../services/reminder_list_service.dart';

class ReminderListDependencies {
  ReminderListDependencies._(this.context);

  factory ReminderListDependencies.of(BuildContext context) => _instance != null
      ? _instance!
      : _instance = ReminderListDependencies._(context);

  static ReminderListDependencies? _instance;

  final BuildContext context;

  late List<SingleChildWidget> providers = [
    ..._repositories,
    ..._services,
    ..._blocs,
  ];

  late final List<Provider> _repositories = [];

  late final List<Provider> _services = [
    Provider<ReminderListService>(
      create: (context) => ReminderListService(
      ),
    ),
  ];

  late final List<RxBlocProvider> _blocs = [
    RxBlocProvider<ReminderListBlocType>(
      create: (context) => ReminderListBloc(
        context.read(),
        context.read(),
        context.read(),
      ),
    ),
  ];
}
